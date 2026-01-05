# Used to build website.
# See PL/website/Makefile.
git add -A
if git diff-index --quiet HEAD; [[ "$?"  -eq 1 ]]
then
	echo "Committing local changes."
	git commit -m "Updating the PL website."
	git push origin main
	exit 0
fi
echo "No changes to commit."
exit 0