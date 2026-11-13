#!/bin/sh
# Publishes the Sotto project on GitHub in one go:
#   - creates the 8 repositories (sotto and sotto-*) under OWNER, public or private
#   - pushes them (the SDK first, the umbrella last, so every submodule commit exists)
#   - enables GitHub Pages (from Actions) for the website in `sotto`
#   - creates the "Sotto" project board, links every repository to it, and opens one tracking
#     issue per component (its sub-project) plus the known open items, all on the board
#
# Needs the GitHub CLI, logged in with the right scopes:
#   gh auth login --scopes "repo,workflow,project"
# Run from the umbrella repository; the component repositories are its sibling folders:
#   sh tools/github-setup.sh OWNER public|private
set -eu
OWNER=${1:?usage: github-setup.sh OWNER public|private}
VIS=${2:?usage: github-setup.sh OWNER public|private}
case "$VIS" in public|private) ;; *) echo "visibility: public or private"; exit 2 ;; esac
ROOT=$(cd "$(dirname "$0")/.." && pwd)
WS=$(dirname "$ROOT")

repo_desc() {
    case "$1" in
        sotto)         echo "Sotto: open toolkit for VBAN network audio. SDK, players, virtual sound cards, OpenWrt hub" ;;
        sotto-sdk)     echo "Zero-allocation C99 SDK for the VBAN audio protocol, with secure VBAN" ;;
        sotto-app)     echo "sotto: VBAN to and from any sound device on Windows, macOS and Linux" ;;
        sotto-linux)   echo "VBAN sound cards for Linux: ALSA kernel module and PipeWire devices" ;;
        sotto-windows) echo "VBAN virtual sound card for Windows (Scream-based driver)" ;;
        sotto-macos)   echo "VBAN virtual audio devices for macOS (CoreAudio AudioServerPlugIn)" ;;
        sotto-android) echo "VBAN for Android: Kotlin library over the Sotto SDK" ;;
        sotto-hub)     echo "OpenWrt hub for VBAN: routing, LuCI, secure VBAN CA, eBPF fast path" ;;
    esac
}
component() {
    case "$1" in
        sotto-sdk) echo SDK ;; sotto-app) echo App ;; sotto-linux) echo Linux ;; sotto-windows) echo Windows ;;
        sotto-macos) echo macOS ;; sotto-android) echo Android ;; sotto-hub) echo Hub ;; *) echo Project ;;
    esac
}

ORDER="sotto-sdk sotto-app sotto-linux sotto-windows sotto-macos sotto-android sotto-hub sotto"

gh auth status >/dev/null || { echo "log in first: gh auth login --scopes repo,workflow,project"; exit 1; }
gh auth setup-git

echo "== repositories"
for r in $ORDER; do
    dir=$WS/$r; [ "$r" = sotto ] && dir=$ROOT
    if ! gh repo view "$OWNER/$r" >/dev/null 2>&1; then
        gh repo create "$OWNER/$r" --"$VIS" --description "$(repo_desc $r)" --disable-wiki
    fi
    gh repo edit "$OWNER/$r" --add-topic vban --add-topic audio --add-topic network-audio --add-topic sotto >/dev/null
    git -C "$dir" remote remove github 2>/dev/null || true
    git -C "$dir" remote add github "https://github.com/$OWNER/$r.git"
    git -C "$dir" push github main
done

echo "== GitHub Pages for the website"
gh api -X POST "repos/$OWNER/sotto/pages" -f build_type=workflow >/dev/null 2>&1 || \
    gh api -X PUT "repos/$OWNER/sotto/pages" -f build_type=workflow >/dev/null 2>&1 || \
    echo "   (enable Pages by hand: sotto > Settings > Pages > Source: GitHub Actions)"

echo "== project board"
NUM=$(gh project list --owner "$OWNER" --format json --jq '.projects[] | select(.title=="Sotto") | .number' 2>/dev/null | head -1)
if [ -z "$NUM" ]; then
    NUM=$(gh project create --owner "$OWNER" --title "Sotto" --format json --jq .number)
fi
for r in $ORDER; do gh project link "$NUM" --owner "$OWNER" --repo "$r" >/dev/null 2>&1 || true; done

issue() {   # repo, title, body -> adds it to the board
    url=$(gh issue create --repo "$OWNER/$1" --title "$2" --body "$3")
    gh project item-add "$NUM" --owner "$OWNER" --url "$url" >/dev/null
    echo "   $url"
}
echo "== sub-projects (one tracking issue per component) and open items"
for r in $ORDER; do
    [ "$r" = sotto ] && continue
    issue "$r" "$(component $r): roadmap" "Tracking issue for the $(component $r) part of Sotto ($(repo_desc $r)). Sub-tasks of this component link here."
done
issue sotto-windows "First build and install on Windows" "Build SottoVBAN with the WDK (CI does), install with test signing, check that \"Sotto out\" sends VBAN to sotto play / Voicemeeter."
issue sotto-windows "Microsoft attestation signing" "Needed to install the driver without test signing (EV code-signing certificate)."
issue sotto-macos "First run on a Mac" "make; sudo make install; check \"Sotto Out\" and \"Sotto In\" with sotto send / play."
issue sotto-hub "Secure VBAN over a real internet link" "Tested with a simulated internet (bench/vm-internet-test.sh); try a phone on mobile data through the hub."
echo "== done: https://github.com/$OWNER/sotto  (project board: https://github.com/users/$OWNER/projects/$NUM or the organization's Projects tab)"
