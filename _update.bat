set /p commit_log=������ commit ��־��Ϣ:
cd book
git status
git add -A
git commit -m "%commit_log%"
git push origin master
pause