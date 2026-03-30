# Day 4 — Git Interview Questions 🔥

---

## Basic Level

**Q1. What is a branch in Git?**
A branch is an independent line of development. It allows you to work on new features or fixes without affecting the main/stable codebase. Internally, a branch is just a pointer to a commit.

**Q2. What is the difference between `git merge` and `git rebase`?**
- `git merge` combines two branches and creates a new merge commit — preserves full history
- `git rebase` moves your commits on top of another branch — creates a clean, linear history
- Use merge for preserving context, use rebase for clean history before merging

**Q3. What is a Fast-forward merge?**
When the feature branch is ahead of main and main has no new commits since the branch was created, Git simply moves the main pointer forward to the feature branch tip — no new merge commit is created. This is called a fast-forward merge.

**Q4. What does `git stash` do?**
`git stash` temporarily saves your uncommitted changes (both staged and unstaged) and cleans your working directory. You can later restore them using `git stash pop`. Useful when you need to switch branches but aren't ready to commit.

**Q5. What is the difference between `git reset` and `git revert`?**
- `git reset` removes commits from history — dangerous, especially on shared branches
- `git revert` creates a new commit that undoes the changes — safe, preserves history
- Always use `git revert` in production/shared branches

---

## Intermediate Level

**Q6. What is HEAD in Git?**
HEAD is a pointer that tells Git which commit/branch you are currently on. `HEAD -> main` means you are on the main branch. `HEAD~1` means one commit behind current HEAD.

**Q7. What is the difference between `git reset --soft`, `--mixed`, and `--hard`?**
- `--soft` → Undoes commit, keeps changes staged
- `--mixed` (default) → Undoes commit, unstages changes, keeps files
- `--hard` → Undoes commit, deletes all changes permanently ⚠️

**Q8. When would you use `git rebase` instead of `git merge`?**
Use rebase when:
- You want a clean, linear commit history
- Before merging a feature branch into main (rebase first, then merge)
- Working on a local/personal branch that hasn't been shared
Avoid rebase on shared/public branches — it rewrites history and causes conflicts for teammates.

**Q9. What happens to the commit hash after a rebase?**
Rebase recreates each commit on top of the new base. Since the parent commit changes, the SHA hash of each rebased commit also changes. This is why rebased commits are called `E'` (E prime) — same changes, new identity.

**Q10. What is the difference between `git branch -d` and `git branch -D`?**
- `-d` (lowercase) = safe delete — Git refuses to delete if the branch hasn't been merged
- `-D` (uppercase) = force delete — deletes regardless of merge status

---

## Scenario Based

**Q11. You accidentally committed to main instead of a feature branch. What do you do?**
```bash
git reset HEAD~1          # undo the commit, keep changes
git checkout -b feature/fix  # create correct branch
git add .
git commit -m "fix: correct branch commit"
```

**Q12. You are in the middle of a feature and urgently need to fix a bug on main. What do you do?**
```bash
git stash                 # save current work
git checkout main
git checkout -b hotfix/bug
# fix the bug
git commit -m "fix: urgent bug"
git checkout feature/my-work
git stash pop             # restore your work
```

**Q13. Your teammate pushed to main and your feature branch is now behind. How do you update?**
```bash
git checkout feature/my-branch
git rebase main           # place your commits on top of latest main
# resolve conflicts if any
git rebase --continue
```

**Q14. You want to undo a commit that was already pushed to remote. What do you do?**
```bash
git revert HEAD           # creates new undo commit
git push                  # safe to push — history preserved
```
Never use `git reset` on already pushed commits — it rewrites history and breaks teammates' repos.

**Q15. What is the difference between `git stash pop` and `git stash apply`?**
- `git stash pop` → restores changes AND deletes the stash entry
- `git stash apply` → restores changes but KEEPS the stash entry (can apply again later)

---

## Advanced Level

**Q16. What is a detached HEAD state?**
When you checkout a specific commit (not a branch), Git enters detached HEAD state — HEAD points directly to a commit instead of a branch. Any commits made here are not attached to any branch and can be lost. To save work, create a new branch: `git checkout -b new-branch`

**Q17. What is the difference between `git fetch` and `git pull`?**
- `git fetch` → downloads changes from remote but does NOT merge into local branch
- `git pull` → fetch + merge in one step
Use fetch when you want to review changes before merging.

**Q18. How do you squash multiple commits into one?**
```bash
git rebase -i HEAD~3      # interactive rebase — last 3 commits
# In editor: change 'pick' to 'squash' for commits to combine
```
Useful for cleaning up messy commit history before merging a PR.

**Q19. What is `git cherry-pick`?**
It applies a specific commit from one branch to another without merging the entire branch.
```bash
git cherry-pick <commit-hash>
```
Useful when you want just one fix from another branch.

**Q20. What is the Golden Rule of Rebasing?**
**Never rebase commits that have been pushed to a shared/public branch.**
Rebase rewrites commit history (new hashes). If teammates have already pulled those commits, their history will diverge and cause major conflicts. Only rebase local/personal branches.

---

## Quick Revision Table

| Command | Use Case |
|---|---|
| `git checkout -b` | Create + switch to new branch |
| `git merge` | Combine branches (preserves history) |
| `git rebase` | Clean linear history |
| `git stash` | Save work temporarily |
| `git stash pop` | Restore saved work |
| `git reset --soft` | Undo commit, keep staged |
| `git reset --mixed` | Undo commit, keep files |
| `git reset --hard` | Undo commit, delete everything ⚠️ |
| `git revert` | Safe undo for production |
| `git cherry-pick` | Apply single commit to another branch |
| `git rebase -i` | Squash/edit commits interactively |

---

## Most Asked in Interviews

1. Merge vs Rebase — **always comes**
2. Reset vs Revert — **always comes**
3. What is HEAD — **always comes**
4. Stash use case scenario — **frequently asked**
5. Golden Rule of Rebasing — **senior level interviews**

**Day 4 Interview Prep — Done! 🔥**
