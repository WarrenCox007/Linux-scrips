# SSH key cleanup

Remove cached host keys before reconnecting to a server:

```bash
ssh-keygen -R 192.168.10.20
```
