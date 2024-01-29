# gpg key를 이용한 서명 사용
* [참고자료](https://www.44bits.io/ko/post/add-signing-key-to-git-commit-by-gpg)
* [왜 gpg key를 이용한 서명을 사용하는가?](https://bitlog.tistory.com/52)

## gpg install 
```bash
brew install gpg
```

## generate gpg key
```bash
gpg --gen-key
```

## show exist key
```bash
 gpg --list-secret-keys
gpg: checking the trustdb
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: depth: 0  valid:   1  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 1u
gpg: next trustdb check due at 2027-01-23
[keyboxd]
---------
sec   ed25519 2024-01-24 [SC] [expires: 2027-01-23]
      <YOURE_GPG_PUB_KEY_FINGERPRINT>
uid           [ultimate] juner417 <juner84s@gmail.com>
ssb   cv25519 2024-01-24 [E] [expires: 2027-01-23]
```

## export key for GHE
```bash
gpg --armor --export <YOURE_GPG_PUB_KEY_FINGERPRINT>
-----BEGIN PGP PUBLIC KEY BLOCK-----
...
-----END PGP PUBLIC KEY BLOCK-----
```

## add gpg key on GHE
![gpg](./asset/gpg-ghe.png)




## issue
```bash
> git commit -m "first commit"
error: gpg failed to sign the data
fatal: failed to write commit object
```

```bash
GIT_TRACE=1 git commit -m "first commit"
19:11:32.011097 exec-cmd.c:139          trace: resolved executable path from Darwin stack: /Library/Developer/CommandLineTools/usr/bin/git
19:11:32.011469 exec-cmd.c:238          trace: resolved executable dir: /Library/Developer/CommandLineTools/usr/bin
19:11:32.011921 git.c:460               trace: built-in: git commit -m 'first commit'
19:11:32.013202 run-command.c:655       trace: run_command: gpg --status-fd=2 -bsau 4AD49B810C71D9ACCEXXXXXXXX694D0C939149E
error: gpg failed to sign the data
fatal: failed to write commit object
```

* solution 
  * [link](https://gist.github.com/paolocarrasco/18ca8fe6e63490ae1be23e84a7039374?permalink_comment_id=3767413)
```bash
#1
gpg --version
#2
echo "test" | gpg --clearsign
gpg: signing failed: Inappropriate ioctl for device
gpg: [stdin]: clear-sign failed: Inappropriate ioctl for device
#3
export GPG_TTY=$(tty)
#4
echo "test" | gpg --clearsign
-----BEGIN PGP SIGNED MESSAGE-----
...
-----END PGP SIGNATURE-----

# success a commit 
GIT_TRACE=1 git commit -m "first commit"
19:14:34.870667 exec-cmd.c:139          trace: resolved executable path from Darwin stack: /Library/Developer/CommandLineTools/usr/bin/git
19:14:34.871046 exec-cmd.c:238          trace: resolved executable dir: /Library/Developer/CommandLineTools/usr/bin
19:14:34.871575 git.c:460               trace: built-in: git commit -m 'first commit'
19:14:34.873335 run-command.c:655       trace: run_command: gpg --status-fd=2 -bsau 4AD49B810C71D9ACCEXXXXXXXX694D0C939149E
19:14:35.012904 run-command.c:655       trace: run_command: git maintenance run --auto --no-quiet
19:14:35.015098 exec-cmd.c:139          trace: resolved executable path from Darwin stack: /Library/Developer/CommandLineTools/usr/libexec/git-core/git
19:14:35.015351 exec-cmd.c:238          trace: resolved executable dir: /Library/Developer/CommandLineTools/usr/libexec/git-core
19:14:35.015602 git.c:460               trace: built-in: git maintenance run --auto --no-quiet
[main (root-commit) 8b0cf45] first commit
 1 file changed, 1 insertion(+)
 create mode 100644 README.md
```
