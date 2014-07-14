# test-kitchen test （test-kitchenハンズオン資料）インフラも継続的インテグレーション！

社内LT用資料です。

# 前提

* anyenv やら rbenvやらを使ってrubyをインストールしておく
* このリポジトリをgit clone する人、かつ、chef-dkを使っていない人（この資料はchef-dkを使用していない場合のコマンドで書いています）

```
$ cd test-kitchen-test/
$ bundle install
-> vendor/bundle/ 配下にtest-kitchenがインストールされる
```
* chef-dkを使うとchef、test-kitchen、berkshelf等がインストールされているので、以下の手順の中に出てくる `bundle exec` はいらないです。
  * 例： `bundle exec kitchen list` -> `kitchen list`


# test-kitchenとは？

* chef cookbookをテストするためのツール
* 好きな仮想サーバでテストができる
  * vagrant、docker、ec2、azure、gce等
* Busser（ビュッセル）ライブラリによって好きなサーバ設定自動化ツールでテストができる
  * chef、puppet、ansible等
* 好きなテストコードでテストができる
  * serverspec、Bats、minitest等

# URL

* [公式](http://kitchen.ci/)
* [opscodeマニュアル](http://docs.opscode.com/ctl_kitchen.html)
* [本：Chef実践入門-~コードによるインフラ構成の自動化-](http://www.amazon.co.jp/dp/477416500X/)
* [Busser-serverspec](http://sssslide.com/speakerdeck.com/d_higuchi/about-busser-serverspec)

# test-kitchenコマンドの流れを `ざっくり` 理解する


![test-kitchen-zakkuri.png](https://qiita-image-store.s3.amazonaws.com/0/17518/2d8b1bca-fd31-1714-b8a6-2fef34ec6439.png "test-kitchen-zakkuri.png")


## 押さえておくところ

* いろんなOSをいっぺんにテストできる（図の.kitchen.ymlから矢印が２本出ているところ）
* いろんなテストコードでテストできる（図の吹き出し部分）
* この図のサイクルを運用で回すことによって品質を担保する（図全体）=> CI（継続的インテグレーション）

# サクッとコマンドだけ試したい人

https://github.com/imura81gt/test-kitchen-test

をcloneして、この資料の `test-kitchen ハンズオン！` までお進みください。


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

cookbook 'apt'
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

（以下、まとめ中）


## test-kitchenコマンドの流れを `コマンド` で理解する

![test-kitchen-flow.png](https://qiita-image-store.s3.amazonaws.com/0/17518/ffb98245-61b2-686f-7fd4-e9cbc7e3ffb2.png "test-kitchen-flow.png")


## apache2をインスタンスに適用する

### web roleを作成する

```roles/web.json
{
    "name": "web",
    "json_class": "Chef::Role",
    "description": "web role",
    "default_attributes": {
      "apache": {
      }
    },
    "run_list": [
        "recipe[apache2]"
    ],
    "chef_type": "role"
}
```

### ubuntu roleを作成する

apt-get updateを実行しないといろいろ動かない

```roles/ubuntu.json
{
    "name": "ubuntu",
    "json_class": "Chef::Role",
    "description": "ubuntu role",
    "default_attributes": {
    },
    "run_list": [
        "recipe[apt]"
    ],
    "chef_type": "role"
}
```


### web role、ubuntu roleが適用されるように .kitchen.ymlを修正する

```ruby:.kitchen.yml
---
driver:
  name: vagrant

provisioner:
  name: chef_solo

platforms:
  - name: ubuntu-12.04
    run_list:
      - role[ubuntu]
  - name: centos-6.4

suites:
  - name: default
    run_list:
      - role[web]
    attributes:
```

### 試しに起動／cookbook適用してみる（converge）

```bash:
$ bundle exec kitchen converge
```

```bash:
$ bundle exec kitchen list
Instance             Driver   Provisioner  Last Action
default-ubuntu-1204  Vagrant  ChefSolo     Converged
default-centos-64    Vagrant  ChefSolo     Converged
$
```

## テストコードを書く

### serverspec

```bash:
$ cd test/integration/default/
$
$ bundle exec serverspec-init
Select OS type:

  1) UN*X
  2) Windows

Select number: 1

Select a backend type:

  1) SSH
  2) Exec (local)

Select number: 2

 + spec/
 + spec/localhost/
 + spec/localhost/httpd_spec.rb
 + spec/spec_helper.rb
 + Rakefile
$
```

test-kitchenでは
serverspec/*/*_spec.rb をテストコードとして実行するため
フォルダ名を変更する

```bash:
$ mv spec/ serverspec/
```

### テストコードを実行してみる(verify)


.kitchen.yml があるディレクトリに戻って実行

```bash:
$ bundle exec kitchen verify
```

-> ubuntuでapacheをインストールするとpackage名がhttpdじゃなかったして、
　　ubuntuのテストがほとんど失敗するので
　　CentOSのテストだけを流してみる


```bash:
$ bundle exec kitchen verify default-centos-64

（省略）

       Finished in 0.18527 seconds
       6 examples, 1 failure

       Failed examples:

       rspec /tmp/busser/suites/serverspec/localhost/httpd_spec.rb:18 # File "/etc/httpd/conf/httpd.conf" content should match /ServerName localhost/
       /opt/chef/embedded/bin/ruby -I/tmp/busser/suites/serverspec -S /opt/chef/embedded/bin/rspec /tmp/busser/suites/serverspec/localhost/httpd_spec.rb --color --format documentation failed
       Ruby Script [/tmp/busser/gems/gems/busser-serverspec-0.2.6/lib/busser/runner_plugin/../serverspec/runner.rb /tmp/busser/suites/serverspec] exit code was 1
>>>>>> Verify failed on instance <default-centos-64>.
>>>>>> Please see .kitchen/logs/default-centos-64.log for more details
>>>>>> ------Exception-------
>>>>>> Class: Kitchen::ActionFailed
>>>>>> Message: SSH exited (1) for command: [sh -c 'BUSSER_ROOT="/tmp/busser" GEM_HOME="/tmp/busser/gems" GEM_PATH="/tmp/busser/gems" GEM_CACHE="/tmp/busser/gems/cache" ; export BUSSER_ROOT GEM_HOME GEM_PATH GEM_CACHE; sudo -E /tmp/busser/bin/busser test']
>>>>>> ----------------------
$
```

テストが混ざっているのでコメントアウトする

```ruby:test/integration/default/serverspec/localhost/httpd_spec.rb
require 'spec_helper'

describe package('httpd') do
  it { should be_installed }
end

describe service('httpd') do
  it { should be_enabled   }
  it { should be_running   }
end

describe port(80) do
  it { should be_listening }
end

#describe file('/etc/httpd/conf/httpd.conf') do
#  it { should be_file }
#  its(:content) { should match /ServerName localhost/ }
#end
```

もう一度テストを流してみる

```bash:
$ bundle exec kitchen verify default-centos-64
-----> Starting Kitchen (v1.2.1)
-----> Verifying <default-centos-64>...
       Removing /tmp/busser/suites/serverspec
       Uploading /tmp/busser/suites/serverspec/localhost/httpd_spec.rb (mode=0644)
       Uploading /tmp/busser/suites/serverspec/spec_helper.rb (mode=0644)
-----> Running serverspec test suite
       /opt/chef/embedded/bin/ruby -I/tmp/busser/suites/serverspec -S /opt/chef/embedded/bin/rspec /tmp/busser/suites/serverspec/localhost/httpd_spec.rb --color --format documentation

       Package "httpd"
         should be installed

       Service "httpd"
         should be enabled
         should be running

       Port "80"
         should be listening

       Finished in 0.16363 seconds
       4 examples, 0 failures
       Finished verifying <default-centos-64> (0m2.11s).
-----> Kitchen is finished. (0m2.73s)
$
```

### destroy

```bash:
$ bundle exec kitchen destroy default-centos-64
```

```bash:
$ bundle exec kitchen list
Instance             Driver   Provisioner  Last Action
default-ubuntu-1204  Vagrant  ChefSolo     Set Up
default-centos-64    Vagrant  ChefSolo     <Not Created>
$
```


### convergeやらverifyやらdestoyやらを全部一気に流してみる（test）

```bash:
$ bundle exec kitchen test default-centos-64

（省略）

       Package "httpd"
         should be installed

       Service "httpd"
         should be enabled
         should be running

       Port "80"
         should be listening

       Finished in 0.16632 seconds
       4 examples, 0 failures
       Finished verifying <default-centos-64> (0m2.11s).
-----> Destroying <default-centos-64>...
       ==> default: Forcing shutdown of VM...
       ==> default: Destroying VM and associated drives...
       Vagrant instance <default-centos-64> destroyed.
       Finished destroying <default-centos-64> (0m5.01s).
       Finished testing <default-centos-64> (5m51.67s).
-----> Kitchen is finished. (5m52.26s)
$
```







# test-kitchen ハンズオン！

```
$ cd /path/to/work/
$ git clone https://github.com/imura81gt/test-kitchen-test
$ cd test-kitchen-test/
$ bundle install
$ bundle exec kitchen
-> ヘルプを参照する

$ bundle exec kitchen list
-> test-kitchenで起動するインスタンスを確認する

$ cat .kitchen.yml
-> test-kitchenで起動するインスタンス情報を確認する

$ bundle exec kitchen create
-> インスタンスを起動する

$ bundle exec kitchen list
-> ２つインスタンスが起動していることを確認する
-> `Last Action` が `Created`

$ ls .kitchen/kitchen-vagrant/*/Vagrantfile
$ cat .kitchen/kitchen-vagrant/default-centos-64/Vagrantfile 
$ cat .kitchen/kitchen-vagrant/default-ubuntu-1204/Vagrantfile
-> .kitchen.yamlの情報を元にVagrantfileが作成されていることを確認する


$ bundle exec kitchen converge
-> インスタンスを起動し、cookbooksを適用する

$ bundle exec kitchen list
-> ２つインスタンスが起動していることを確認する
-> `Last Action` が `Converged`

$ bundle exec kitchen login default-ubuntu-1204
-> ubuntuのインスタンスにログインできることを確認する（終わったらexitする）
-> `bundle exec kitchen lo default-u` といった省略も可能


$ bundle exec kitchen login default-centos-64
-> centosのインスタンスにログインできることを確認する（終わったらexitする）

$ bundle exec kitchen verify
-> テストを実行する（default-ubuntu-1204のテストでコケる）

$ bundle exec kitchen vefiry default-centos-64
-> テストを実行する（成功する）

$ bundle exec kitchen destroy
-> インスタンスを削除する

$ bundle exec kitchen test default-centos-64
-> インスタンスの起動、cookbook適用、テスト実行、インスタンス削除まで一気にテストできることを確認する

$ bundle exec kitchen test default-ubuntu-1204
-> インスタンスの起動、cookbook適用までは上手くいくが、テストが失敗し、インスタンスが起動状態で残っていることを確認する。
```



