# tech613-ttt-app-cicd-jenkins

Tic-tac-toe Node.js app (version 1.2) used for a Jenkins CI/CD pipeline.

- `app/`: the app code
- CI: Jenkins runs the tests on each push to the dev branch, then merges to main
- CD: Jenkins deploys main to an EC2 instance
