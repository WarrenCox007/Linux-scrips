# User management quick reference

Create a new sudo-capable user and switch into the account:

```bash
adduser username
usermod -aG sudo username
su - username
```
