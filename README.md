# Udem-rails

![](https://i.imgur.com/wb8jRyA.png)

[https://udem-rails.herokuapp.com](https://udem-rails.herokuapp.com) *(the site may take a long time to open, because uses the free option on heroku)*

A simple platform for creating courses with lessons and the ability to take them. For sell coursess using payments - [stripe](https://stripe.com/), but still can make free couses.

Build with [Ruby on Rails 6](https://rubyonrails.org/).

**[More Screenshots](#screenshots)**

### Main options

* Sign in with devise (including OAuth: Google, GitHub)
* User roles: admin, teacher, student
* Create course
* Create lessons
* Create comments for lessons
* Create review for course
* Create tags for course
* Search and sorting courses
* Buy course with stripe
* Student get pdf Certificate when completed course
* Approve/unappruve curses by admin
* Statistics of pays
* Analytics for pyas, registratios, etc.
* Log of Activity on platform
* Profile of user
* Upload files with AWS S3 (commented for economy heroku hosting)
* Paste emembed video from Youtube
* Dynamic title for pages
* Google analytics
* Sitemap generator
* Bootstrap 4 layout

## Install

### Clone the repository

```shell
$ git clone git@github.com:romka69/udem-rails.git
$ cd udem-rails
```

### Check your Ruby version

```shell
$ ruby -v
```

The ouput should start with something like `ruby 2.7.1`

If not, install the right ruby version using [rvm](https://rvm.io/) (it could take a while):

```shell
$ rvm install 2.7.1
```

### Install dependencies

Using [Bundler](https://github.com/bundler/bundler) and [Yarn](https://github.com/yarnpkg/yarn):

```shell
$ bundle
$ yarn
```

### Set environment variables

Using Rails credentials. Remove file `config/credentials.yml.enc`, then make

```shell
$ EDITOR=nano rails credentials:edit
```

complete with the openned file as in the example `config/credentials.sample`


### Initialize the database

```shell
$ rails db:create db:migrate db:seed
```

## Developing

```shell
$ rails s
```

## Deploy with Heroku

Push to Heroku production remote:

```shell
$ git push heroku
```

## Screenshots

*If screenshots are not displayed, then they were removed by the hosting. Screenshots are duplicated in the folder `. /screenshots`*

**Main page**
![](https://i.imgur.com/bwV7Xvb.png)

**Courses page**
![](https://i.imgur.com/2Xqi2ml.png)

**Course page**
![](https://i.imgur.com/ymrFWfc.png)

**Lesson page**
![](https://i.imgur.com/IY6xOPs.png)

**PDF Certificate**
![](https://i.imgur.com/CO6QKns.png)

**Users page**
![](https://i.imgur.com/DCNaX60.png)

**User page**
![](https://i.imgur.com/KQkQFmc.png)

**Pays page**
![](https://i.imgur.com/MNbz57L.png)

**Activity logs page**
![](https://i.imgur.com/ldEbp2E.png)

**Analytics page**
![](https://i.imgur.com/dPtB0fy.png)

**Privacy page**
![](https://i.imgur.com/GfO7n9n.png)

**Generated erd schema**
![](https://i.imgur.com/1OevgJB.png)
