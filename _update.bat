set /p commit_log=请输入 commit 日志信息:
cd book
git status
git add -A
git commit -m "%commit_log%"
git push origin master
pause