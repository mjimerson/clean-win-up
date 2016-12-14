# Clean-Win-Up
##### Author: Maria Jimerson | mjimerson@ctmsohio.com

This script will install Chocolatey and then force an install of Sysinternals' Handle program. This is used in order to find any processes that are accessing the windowsupdate.log file and kill the open handles. After all handles are closed, the script will clear out the log file.

It then stops and disables Windows Updates services and N-able's Windows Agent. Finally, the script will empty the contents of the Software Distribution folders and restart the services and writes a log file to C: drive. (C:\cleanwinup.log)

##### *Licenced under __GNU General Public License__*