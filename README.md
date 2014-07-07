test-kitchen test （test-kitchenハンズオン）


# 前提

* anyenv やら rbenvやらを使ってruby 2.1.0 の環境にしておく。
  * （というか、なにも考えずに作り始めて、そのバージョンで作ってしまった…）


# 準備

オマエの作ったgitリポジトリなんか使わないぜ！って人向け。
全部自分でやりたい人向け。です。

## chef リポジトリ

```
$ knife solo init test-kitchen-test
```

この時点でのディレクトリ構成

```bash:
$ tree -a test-kitchen-test/
test-kitchen-test/
├── .chef
│   └── knife.rb
├── .gitignore
├── Berksfile
├── cookbooks
│   └── .gitkeep
├── data_bags
│   └── .gitkeep
├── environments
│   └── .gitkeep
├── nodes
│   └── .gitkeep
├── roles
│   └── .gitkeep
└── site-cookbooks
    └── .gitkeep

7 directories, 9 files
$
```


## git

```
$ cd test-kitchen-test/
$ git init
```

## bundle

### 初期化

```
$ bundle init
Writing new Gemfile to /path/test-kitchen-test/Gemfile
$
```
-> Gemfileが作成される

### test-kitchen等インストール

#### Gemfile

```Gemfile
# A sample Gemfile
source "https://rubygems.org"

# gem "rails"

gem 'test-kitchen'
gem 'kitchen-vagrant'
gem 'berkshelf'
gem 'serverspec'
gem 'rake'
gem 'knife-solo'
```

#### インストール

```bash:
$ bundle install --path vendor/bundle
```

-> 時間がかかるので待つ

## test-kitchen

### 初期化

```
$ bundle exec kitchen init
      create  .kitchen.yml
      create  test/integration/default
      append  .gitignore
      append  .gitignore
$
```

## Berkself

### Berksfile

```Berksfile
site :opscode

cookbook 'apache2'
```

-> 何かしら入れておかないと kitchen test が途中でこける

```bash:
[2014-07-01T14:09:28+00:00] ERROR: None of the cookbook paths set in Chef::Config[:cookbook_path], ["/tmp/kitchen/cookbooks", "/tmp/kitchen/site-cookbooks"], contain any cookbooks
[2014-07-01T14:09:28+00:00] FATAL: Chef::Exceptions::ChildConvergeError: Chef run process exited unsuccessfully (exit code 1)
>>>>>> Converge failed on instance <default-ubuntu-1204>.
>>>>>> Please see .kitchen/logs/default-ubuntu-1204.log for more details
>>>>>> ------Exception-------
>>>>>> Class: Kitchen::ActionFailed
>>>>>> Message: SSH exited (1) for command: [sudo -E chef-solo --config /tmp/kitchen/solo.rb --json-attributes /tmp/kitchen/dna.json  --log_level info]
>>>>>> ----------------------
$
```



## github

### リポジトリ作成

（割愛）

## git commit


```bash:
$ touch README.md
$ git add .
$ git commit -m "first commit"
$ git remote add origin https://github.com/imura81gt/test-kitchen-test
$ git push -u origin master
```


# 試しに動かしてみる

この設定で試しに動かしてみる

```.kitchen.yml
---
driver:
  name: vagrant

provisioner:
  name: chef_solo

platforms:
  - name: ubuntu-12.04
  - name: centos-6.4

suites:
  - name: default
    run_list:
    attributes:
```

### ヘルプ

```bash:
$ bundle exec kitchen
Commands:
  kitchen console                         # Kitchen Console!
  kitchen converge [INSTANCE|REGEXP|all]  # Converge one or more instances
  kitchen create [INSTANCE|REGEXP|all]    # Create one or more instances
  kitchen destroy [INSTANCE|REGEXP|all]   # Destroy one or more instances
  kitchen diagnose [INSTANCE|REGEXP|all]  # Show computed diagnostic configuration
  kitchen driver                          # Driver subcommands
  kitchen driver create [NAME]            # Create a new Kitchen Driver gem project
  kitchen driver discover                 # Discover Test Kitchen drivers published on RubyGems
  kitchen driver help [COMMAND]           # Describe subcommands or one specific subcommand
  kitchen help [COMMAND]                  # Describe available commands or one specific command
  kitchen init                            # Adds some configuration to your cookbook so Kitchen can rock
  kitchen list [INSTANCE|REGEXP|all]      # Lists one or more instances
  kitchen login INSTANCE|REGEXP           # Log in to one instance
  kitchen setup [INSTANCE|REGEXP|all]     # Setup one or more instances
  kitchen test [INSTANCE|REGEXP|all]      # Test one or more instances
  kitchen verify [INSTANCE|REGEXP|all]    # Verify one or more instances
  kitchen version                         # Print Kitchen's version information

$
```

### list

test-kitchenで作成される環境のリスト

```
$ bundle exec kitchen list
Instance             Driver   Provisioner  Last Action
default-ubuntu-1204  Vagrant  ChefSolo     <Not Created>
default-centos-64    Vagrant  ChefSolo     <Not Created>
$
```

.kitchen.ymlの設定

```抜粋
platforms:
  - name: ubuntu-12.04
  - name: centos-6.4

suites:
  - name: default
```

-> `platforms:` と `suites:` の値の組み合わせ分テストを行える

### 一通りテストしてみる


```bash:
$ bundle exec kitchen test
-----> Starting Kitchen (v1.2.1)
-----> Cleaning up any prior instances of <default-ubuntu-1204>★ubuntuのインスタンスを起動してテストをし始める

（省略）
       Vagrant instance <default-ubuntu-1204> destroyed.
       Finished destroying <default-ubuntu-1204> (0m4.30s).
       Finished testing <default-ubuntu-1204> (1m33.21s).
-----> Cleaning up any prior instances of <default-centos-64>★centosのインスタンスを起動してテストをし始める

（省略）

       Vagrant instance <default-centos-64> destroyed.
       Finished destroying <default-centos-64> (0m4.76s).
       Finished testing <default-centos-64> (2m0.60s).
-----> Kitchen is finished. (3m34.67s)
$
```

-> テストコードをおいていないから何もしてない状態なので参考まで。





# ↑ここまでの状態をgithubに公開

https://github.com/imura81gt/test-kitchen-test

ハンズオンする方はgit cloneしてください。

（以下、まとめ中）

# test-kitchen ハンズオン！

## apache2をインスタンスに適用する

### web roleを作成する

### web role が適用されるように .kitchen.ymlを修正する

### 試しに起動／適用してみる（converge）


## テストコードを書く

### serverspec

## test-kitchenの一連の流れを理解しながらテストする

### setup

### converge

### verify

### destroy

### そして…test






