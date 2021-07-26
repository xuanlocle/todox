# todox

Todo app

<img width="200" alt="018" src="https://github.com/xuanlocle/todox/blob/a9fe4a2639907aabb153913086f22490e30486a7/overview_app.gif"/>


# App download

Android download link：
https://github.com/xuanlocle/todox/blob/d102166e3306fae8c5066335abd23534d12b15ab/todox_v0r1.apk

# Features

- [x] Landing overview todo list
- [x] Landing complete/incomplete todo list
- [x] Add/Update/Remove todo lines
- [x] Select single and select all todo lines
- [x] Save todo list to local database by hive 
- [ ] Milestone of todo list  
- [ ] Login
- [ ] Notice update todo when timeout task
- [ ] Improve UX/UI
- [ ] Notification for update to do



# package | explain
---|---
[hive](https://pub.dev/packages/hive) | local database (nosql)
[hive_generator](https://pub.dev/packages/hive_generator/) | support for build runner
[rxdart](https://pub.dev/packages/rxdart) | support rxdart
[build_runner](https://pub.dev/packages/build_runner) | support generate code by annotates

## Project Structure

The state management framework used by the project is <code>Provider</code> , and the architecture of the entire project is as follows

- The View layer is used to display layouts and is a variety of **StatelessWidget** pages.
- The Model layer is used to process data.
- The Logic layer does not save any data, only logical operations


## Directory Structure

The project directory structure is as follows:

```
├── android
├── build
├── ios
├── lib
├── pubspec.lock
├── pubspec.yaml
├── test
└── todox.iml

```

