# Homeward Tails Adoption Application
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-61-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

The Homeward Tails app is derived from the [Baja Pet Rescue Dog Adoption Application](https://github.com/kasugaijin/baja-pet-rescue/tree/main) created by @kasugaijin who wanted to give back to the grassroots organization from where he adopted his dog in Mexico by building them a web application. Homeward Tails is an application that makes it easy to connect shelters with people who are looking to adopt or foster pets.

---

# 🚀 Getting Started

Let's get your machine setup to start up the application!

## Docker

Install a containerization app, such as Docker Desktop.

Clone the repo to your local machine and navigate to the directory and run:

`docker-compose build` to build the base image.

`docker-compose up`  to start the containers. You can add the `-d` flag to run silently without logging.

`docker-compose run --rm app bin/setup` to set up and seed the database.

If you need to run migrations at all: `docker-compose run --rm app bin/rails db:migrate`

Visit `localhost:3000` in your browser.

## Local Installation

⚠️  We assume you already have ruby installed with your preferred version manager. This codebase supports [rbenv](
https://github.com/rbenv/rbenv) and [asdf](https://github.com/asdf-vm/asdf-ruby).

### PostgreSQL

Installing PostgreSQL is required to run the application.

#### Installing on MacOS

Instructions: https://wiki.postgresql.org/wiki/Homebrew

```sh
brew install postgresql
```

To run postgresql as a service:

```sh
brew services start postgresql
```

#### Installing via docker

A `docker-compose.yml` is provided that will run postgres inside a local docker container without requiring a full OS install.

Before bringing the image up, you'll need to choose a database username and password by exporting the following environment variables.

Using [direnv] is recommended here, to manage environment variables locally.

```
export DATABASE_USERNAME=[your username]
export DATABASE_PASSWORD=[a password]
```

Once your environment has been set, you may launch the postgres database, and any other dependencies, by running `docker compose up -d`

[direnv]: https://direnv.net/

## Install & Setup

Clone the codebase 
```
git clone git@github.com:rubyforgood/pet-rescue.git
```

Create a new `config/application.yml` file from the `config/application.example.yml`:
```
cp config/application.example.yml config/application.yml
```

Update your `config/application.yml` by replacing the places that say REPLACE_ME. If you installed and configured PostgreSQL as discussed above
you can use your username and leave the password blank for development.

Run the setup script to prepare DB and assets
```sh
bin/setup
```

To run the app locally, use:
```
bin/dev
```

You should see the seed organization by going to:
```
http://localhost:3000/alta/
```

## Login Credentials

All users are scoped to an organization. Hence, you must login via the correct
login portal per organization. 

You can use the following login credentials to login to http://localhost:3000/alta:

Use the following login 
Adopter 
- email: `adopter1@alta.com` 
- password: `123456`

Staff
- email: `staff@alta.com`
- password: `123456`


# 🧪 Running Tests

Run unit tests only
```
./bin/rails test
```

Run system tests only (Headless)
```
./bin/rails test:system
```

Run system tests only (Not-Headless)
```
CI=false ./bin/rails test:system
```

**Note:** If system tests are failing for you, try prepending the command with `APP_HOST=localhost`. Your host might be misconfigured.
```
APP_HOST=localhost ./bin/rails test:system
```

Run ALL tests:
```
./bin/rails test:all
```
## Troubleshoot
<details>
  <summary>Test Errors</summary>
  - System tests Error TCP Connection refused
  
  Fix: chromium install

  [Case in point](https://github.com/rubyforgood/pet-rescue/pull/763#issuecomment-2140971709)
  
</details>


# 💅 Linting 

We use [standard](https://github.com/standardrb/standard) for linting. It provides a command for auto-fixing errors:

```sh
rails standard:fix
```

# Authorization

If you find yourself writing a conditional checking the question, "Is the user **allowed** to view/do this?" that is an authorization concern. Homeward Tails utilizes the gem [Action Policy](https://github.com/palkan/action_policy) as our authorization framework. If you are familiar with Pundit, you will see many similarities. If you want to learn more about authorization or have questions about how Action Policy works, [their documentation](https://actionpolicy.evilmartians.io/#/) is excellent. If you would like a quick onboarding to how Action Policy is used in Homeward Tails, see [our wiki page on authorization](https://github.com/rubyforgood/pet-rescue/wiki/Authorization).

# 🔨 Tools

This [google sheets](https://docs.google.com/spreadsheets/d/1kPDeLicDu1IFkjWEXrWpwT36jtvoMVopEBiX-5L-r1A/edit?usp=sharing) contains a list of tools, their purposes, and who has access to grant permissions.


## 🤝 Contributing Guidelines

Please feel free to contribute! Priority will be given to pull requests that address outstanding issues and have appropriate test coverage. Focus on issues tagged with the next milestone for higher priority.

To contribute:
* Identify an unassigned issue
* Only work on one issue at a time
* Request assignment of an issue by adding a comment on the issue
* Fork the repo if you're not yet a contributor
* Ensure that the application runs locally in your browser. When you run the test suite locally, it should pass
* Create a new branch for the issue using the format `XXX-brief-description-of-feature`, where `XXX` is the issue number
* Make code changes related to the assigned issue
* Commit locally using descriptive messages that indicate the affected parts of the application
* Add tests related to your work(most of the time)
* Ensure all tests pass successfully; if any fail, fix the issues causing the failures
* Make a final commit if any code changes are required
* Push up the branch
* Create a pull request and fill out the description fields
* We like to make sure people are recognized for their contributions, so please attribute others by commenting on a pull request with

  ```
  @all-contributors
  please add @<username> for <contributions>. 
  please add @<username> for <contributions>.
  ```
  Replace `<contributions>` with `code` or `review`

# 📖 About

## Ruby for Good
Homeward Tails is one of many projects initiated and run by Ruby for Good. You can find out more about Ruby for Good at https://rubyforgood.org

# 🌟 Core Values
While vision is the destination, and strategy is how we'll get there, core values are what we'll use to handle times of change or uncertainty (both of which are expected, guaranteed to happen, and positive signs of growth!).

We are committed to promoting positive culture and outcomes for all, from coders and maintainers and leads
to pet rescue and adoption administrators -- and animals everywhere.

We will lean on the following as guiding principles when interacting with others -- stakeholders, as well as current and future maintainers, leads, and collaborators -- and we ask that anyone engaging with this project in any capacity to do the same. Know that we do want to know how and when (not if) we can improve upon these values and/or the way in which we live by and act in accordance with them, so please comment here and in PRs when you have ideas.

Here are our core values defined by early contributors and leads:

### Code Quality and Collaboration
Write maintainable code that is accessible and enjoyable (for beginners and seasoned coders alike), supports and encourages contributors and their contributions, and ensures long-term sustainability of this project and the efforts it supports.

### Communication and Perspective:
Prioritize clear communication, embrace diverse viewpoints, and always engage feedback -- all with a commitment to timely responses and ongoing improvement for all. Rescue and adoption partner perspectives will be prioritized over abstracted conceptualization of their needs.

### Engagement and Practicality:
Build upon stakeholder partnerships to foster and encourage their active involvement, focusing constructive discussion and dispute resolution on the practical impact of our collective work.


---

# 📚Knowledge Base

## Useful resources
These are some resources that may help with contributing to the codebase
* [Figma site design](https://www.figma.com/file/0jVgYASUJy0KiX3BVc3dFM/Tasks?type=design&node-id=0-1&mode=design)
* Model association diagram: Import the schema.rb file into https://dbdiagram.io/d to get the latest version of the diagram
* [Turbo Rails Tutorial](https://www.hotrails.dev/turbo-rails)
* [Geek UI Documentation](https://geeksui.codescandy.com/geeks/docs/index.html)


## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/kasugaijin"><img src="https://avatars.githubusercontent.com/u/95949082?v=4?s=100" width="100px;" alt="Ben"/><br /><sub><b>Ben</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=kasugaijin" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/marlena-b"><img src="https://avatars.githubusercontent.com/u/96994176?v=4?s=100" width="100px;" alt="Marlena Borowiec"/><br /><sub><b>Marlena Borowiec</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=marlena-b" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Ptrboro"><img src="https://avatars.githubusercontent.com/u/16762860?v=4?s=100" width="100px;" alt="Piotr Borowiec"/><br /><sub><b>Piotr Borowiec</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=Ptrboro" title="Code">💻</a> <a href="https://github.com/rubyforgood/homeward-tails/pulls?q=is%3Apr+reviewed-by%3APtrboro" title="Reviewed Pull Requests">👀</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/yuricarvalhop"><img src="https://avatars.githubusercontent.com/u/20230045?v=4?s=100" width="100px;" alt="Yuri Pains"/><br /><sub><b>Yuri Pains</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=yuricarvalhop" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://reyes-dev.github.io/portfolio-site/"><img src="https://avatars.githubusercontent.com/u/102765102?v=4?s=100" width="100px;" alt="Jarrod Reyes"/><br /><sub><b>Jarrod Reyes</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=reyes-dev" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://erinclaudio.com"><img src="https://avatars.githubusercontent.com/u/20326770?v=4?s=100" width="100px;" alt="Erin Claudio"/><br /><sub><b>Erin Claudio</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=ErinClaudio" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://edwinmak.com"><img src="https://avatars.githubusercontent.com/u/11335191?v=4?s=100" width="100px;" alt="Edwin Mak"/><br /><sub><b>Edwin Mak</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=edwinthinks" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/jadekstewart3"><img src="https://avatars.githubusercontent.com/u/114014697?v=4?s=100" width="100px;" alt="Jade Stewart"/><br /><sub><b>Jade Stewart</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=jadekstewart3" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://vernespendic.com"><img src="https://avatars.githubusercontent.com/u/31761693?v=4?s=100" width="100px;" alt="Vernes"/><br /><sub><b>Vernes</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=BakiVernes" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://marchandmd.github.io"><img src="https://avatars.githubusercontent.com/u/35391349?v=4?s=100" width="100px;" alt="Michael Marchand"/><br /><sub><b>Michael Marchand</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=MarchandMD" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Yuji3000"><img src="https://avatars.githubusercontent.com/u/108035840?v=4?s=100" width="100px;" alt="Yuji K."/><br /><sub><b>Yuji K.</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=Yuji3000" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/jmilljr24"><img src="https://avatars.githubusercontent.com/u/16829344?v=4?s=100" width="100px;" alt="Justin"/><br /><sub><b>Justin</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=jmilljr24" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/gorangorun"><img src="https://avatars.githubusercontent.com/u/89098560?v=4?s=100" width="100px;" alt="Goran"/><br /><sub><b>Goran</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=gorangorun" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/phonghpham"><img src="https://avatars.githubusercontent.com/u/9318603?v=4?s=100" width="100px;" alt="Phong Pham"/><br /><sub><b>Phong Pham</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=phonghpham" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://dev.to/diegolinhares"><img src="https://avatars.githubusercontent.com/u/3309779?v=4?s=100" width="100px;" alt="Diego Linhares"/><br /><sub><b>Diego Linhares</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=diegolinhares" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://egemen-dev.github.io/portfolio"><img src="https://avatars.githubusercontent.com/u/93445248?v=4?s=100" width="100px;" alt="Egemen Öztürk"/><br /><sub><b>Egemen Öztürk</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=egemen-dev" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/MooseCowBear"><img src="https://avatars.githubusercontent.com/u/82609260?v=4?s=100" width="100px;" alt="Alisa"/><br /><sub><b>Alisa</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=MooseCowBear" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/nsiwnf"><img src="https://avatars.githubusercontent.com/u/34173394?v=4?s=100" width="100px;" alt="Sree P"/><br /><sub><b>Sree P</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=nsiwnf" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Thrillberg"><img src="https://avatars.githubusercontent.com/u/10481391?v=4?s=100" width="100px;" alt="Eric Tillberg"/><br /><sub><b>Eric Tillberg</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=Thrillberg" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Tomaszabc"><img src="https://avatars.githubusercontent.com/u/131488886?v=4?s=100" width="100px;" alt="Tomaszabc"/><br /><sub><b>Tomaszabc</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=Tomaszabc" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/atbalaji"><img src="https://avatars.githubusercontent.com/u/18101543?v=4?s=100" width="100px;" alt="BALAJI . A . T "/><br /><sub><b>BALAJI . A . T </b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=atbalaji" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/mononoken"><img src="https://avatars.githubusercontent.com/u/81536479?v=4?s=100" width="100px;" alt="Ken Maeshima"/><br /><sub><b>Ken Maeshima</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=mononoken" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://mason-roberts.dev"><img src="https://avatars.githubusercontent.com/u/44660994?v=4?s=100" width="100px;" alt="Mason Roberts"/><br /><sub><b>Mason Roberts</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=Developer3027" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://portfolio-1hab.onrender.com/"><img src="https://avatars.githubusercontent.com/u/61897123?v=4?s=100" width="100px;" alt="Mayank Bhatt"/><br /><sub><b>Mayank Bhatt</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=mayankbhatt07141" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/jeevikasirwani"><img src="https://avatars.githubusercontent.com/u/83456541?v=4?s=100" width="100px;" alt="Jeevika Sirwani"/><br /><sub><b>Jeevika Sirwani</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=jeevikasirwani" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/jp524"><img src="https://avatars.githubusercontent.com/u/85654561?v=4?s=100" width="100px;" alt="Jade"/><br /><sub><b>Jade</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=jp524" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://mehranjavid.github.io/"><img src="https://avatars.githubusercontent.com/u/39021904?v=4?s=100" width="100px;" alt="Mehran Javid"/><br /><sub><b>Mehran Javid</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=mehranjavid" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://uoodsq.github.io"><img src="https://avatars.githubusercontent.com/u/765993?v=4?s=100" width="100px;" alt="Bryan Witherspoon"/><br /><sub><b>Bryan Witherspoon</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=uoodsq" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/dwilsonactual"><img src="https://avatars.githubusercontent.com/u/15931013?v=4?s=100" width="100px;" alt="David Wilson"/><br /><sub><b>David Wilson</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=dwilsonactual" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/gdomingu"><img src="https://avatars.githubusercontent.com/u/4443635?v=4?s=100" width="100px;" alt="Gabe D"/><br /><sub><b>Gabe D</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=gdomingu" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/greggroth"><img src="https://avatars.githubusercontent.com/u/903365?v=4?s=100" width="100px;" alt="Greggory Rothmeier"/><br /><sub><b>Greggory Rothmeier</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=greggroth" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://tpo.pe/"><img src="https://avatars.githubusercontent.com/u/378?v=4?s=100" width="100px;" alt="Tim Pope"/><br /><sub><b>Tim Pope</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=tpope" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/ipc103"><img src="https://avatars.githubusercontent.com/u/6826778?v=4?s=100" width="100px;" alt="Ian Candy"/><br /><sub><b>Ian Candy</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/pulls?q=is%3Apr+reviewed-by%3Aipc103" title="Reviewed Pull Requests">👀</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://vonteacher.github.io"><img src="https://avatars.githubusercontent.com/u/17757205?v=4?s=100" width="100px;" alt="Vaughn Weiss"/><br /><sub><b>Vaughn Weiss</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=VonTeacher" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://harry-kp.github.io/"><img src="https://avatars.githubusercontent.com/u/55315065?v=4?s=100" width="100px;" alt="Harshit Chaudhary"/><br /><sub><b>Harshit Chaudhary</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=Harry-kp" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="http://rarlindseysmash.com"><img src="https://avatars.githubusercontent.com/u/33750?v=4?s=100" width="100px;" alt="Lindsey Bieda"/><br /><sub><b>Lindsey Bieda</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=LindseyB" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/sean-dickinson"><img src="https://avatars.githubusercontent.com/u/90267290?v=4?s=100" width="100px;" alt="Sean Dickinson"/><br /><sub><b>Sean Dickinson</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=sean-dickinson" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/OliverLeighC"><img src="https://avatars.githubusercontent.com/u/51760107?v=4?s=100" width="100px;" alt="Oliver Coley"/><br /><sub><b>Oliver Coley</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=OliverLeighC" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/sarvaiyanidhi"><img src="https://avatars.githubusercontent.com/u/514363?v=4?s=100" width="100px;" alt="Nidhi Sarvaiya"/><br /><sub><b>Nidhi Sarvaiya</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=sarvaiyanidhi" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/elight"><img src="https://avatars.githubusercontent.com/u/10112?v=4?s=100" width="100px;" alt="Evan Light"/><br /><sub><b>Evan Light</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=elight" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/kiryth"><img src="https://avatars.githubusercontent.com/u/110743903?v=4?s=100" width="100px;" alt="Kirin"/><br /><sub><b>Kirin</b></sub></a><br /><a href="#design-kiryth" title="Design">🎨</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/albertabney"><img src="https://avatars.githubusercontent.com/u/12437051?v=4?s=100" width="100px;" alt="albertabney"/><br /><sub><b>albertabney</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=albertabney" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Tacabr0n"><img src="https://avatars.githubusercontent.com/u/158373986?v=4?s=100" width="100px;" alt="Tacabr0n"/><br /><sub><b>Tacabr0n</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=Tacabr0n" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://jamey-alea.com"><img src="https://avatars.githubusercontent.com/u/8495523?v=4?s=100" width="100px;" alt="Jamey Alea"/><br /><sub><b>Jamey Alea</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=jameybash" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Naraveni"><img src="https://avatars.githubusercontent.com/u/170462097?v=4?s=100" width="100px;" alt="Naraveni"/><br /><sub><b>Naraveni</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=Naraveni" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/maebeale"><img src="https://avatars.githubusercontent.com/u/7607813?v=4?s=100" width="100px;" alt="maebeale"/><br /><sub><b>maebeale</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/pulls?q=is%3Apr+reviewed-by%3Amaebeale" title="Reviewed Pull Requests">👀</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://meghangutshall.com/"><img src="https://avatars.githubusercontent.com/u/37842352?v=4?s=100" width="100px;" alt="Meg Gutshall"/><br /><sub><b>Meg Gutshall</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=meg-gutshall" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/jaxonavena"><img src="https://avatars.githubusercontent.com/u/89274915?v=4?s=100" width="100px;" alt="Jaxon"/><br /><sub><b>Jaxon</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=jaxonavena" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/alexanderc360"><img src="https://avatars.githubusercontent.com/u/33144250?v=4?s=100" width="100px;" alt="Alex Cohen"/><br /><sub><b>Alex Cohen</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=alexanderc360" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/sevilla"><img src="https://avatars.githubusercontent.com/u/1185489?v=4?s=100" width="100px;" alt="Kristine Sevilla"/><br /><sub><b>Kristine Sevilla</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=sevilla" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://devcaffeine.com/"><img src="https://avatars.githubusercontent.com/u/3754?v=4?s=100" width="100px;" alt="Chris Flipse"/><br /><sub><b>Chris Flipse</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=cflipse" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Trevor-Robinson"><img src="https://avatars.githubusercontent.com/u/72584659?v=4?s=100" width="100px;" alt="Trevor Robinson"/><br /><sub><b>Trevor Robinson</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=Trevor-Robinson" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/pshong79"><img src="https://avatars.githubusercontent.com/u/1057497?v=4?s=100" width="100px;" alt="pshong79"/><br /><sub><b>pshong79</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=pshong79" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Aaryanpal"><img src="https://avatars.githubusercontent.com/u/53212802?v=4?s=100" width="100px;" alt="Aaryan"/><br /><sub><b>Aaryan</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=Aaryanpal" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/italomatos"><img src="https://avatars.githubusercontent.com/u/836472?v=4?s=100" width="100px;" alt="Ítalo Matos"/><br /><sub><b>Ítalo Matos</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=italomatos" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://kocha.club/"><img src="https://avatars.githubusercontent.com/u/42182755?v=4?s=100" width="100px;" alt="Basil Gray"/><br /><sub><b>Basil Gray</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=basil-gray" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="http://noahdurbin.github.io"><img src="https://avatars.githubusercontent.com/u/13364668?v=4?s=100" width="100px;" alt="Noah Durbin"/><br /><sub><b>Noah Durbin</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=noahdurbin" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://katehiga.com"><img src="https://avatars.githubusercontent.com/u/16447748?v=4?s=100" width="100px;" alt="Kate Higa"/><br /><sub><b>Kate Higa</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=khiga8" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://corystreiff.com"><img src="https://avatars.githubusercontent.com/u/90390502?v=4?s=100" width="100px;" alt="Cory Streiff"/><br /><sub><b>Cory Streiff</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/pulls?q=is%3Apr+reviewed-by%3Acoalest" title="Reviewed Pull Requests">👀</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://wuletawwonte.com"><img src="https://avatars.githubusercontent.com/u/12524453?v=4?s=100" width="100px;" alt="Wuletaw Wonte"/><br /><sub><b>Wuletaw Wonte</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=wuletawwonte" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/MichaScant"><img src="https://avatars.githubusercontent.com/u/89426143?v=4?s=100" width="100px;" alt="michascant"/><br /><sub><b>michascant</b></sub></a><br /><a href="https://github.com/rubyforgood/homeward-tails/commits?author=MichaScant" title="Code">💻</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!

