



rsync --dry-run -avzhe ssh /dir-to-be-copied/* root@<target_server>:/backupdir/

Worked fine. Then tried it as the real deal:

rsync -avzhe ssh /dir-to-be-copied/* root@<target_server>:/backupdir/

Also worked fine.

Then used crontab -e to set up the following, for a nightly transfer:

1 2 * * * rsync -auvzhe ssh /dir-to-be-copied/* root@<target_server>:/backupdir/


