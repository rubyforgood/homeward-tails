# Pet Rescue Adoption Application

The Pet Rescue app is derived from the [Baja Pet Rescue Dog Adoption Application](https://github.com/kasugaijin/baja-pet-rescue/tree/main) created by @kasugaijin who wanted to give back to the grassroots organization from where he adopted his dog in Mexico by building them a web application. Pet Rescue is an application that makes it easy to link adopters with pets.

---

# 🚀 Getting Started

Let's get your machine setup to startup the application!

## Prerequisites

⚠️  We assume you already have ruby installed with your preferred version manager. This codebase supports [rbenv](
https://github.com/rbenv/rbenv) and [asdf](https://github.com/asdf-vm/asdf-ruby).

## Install & Setup

Clone the codebase 
```
git clone git@github.com:rubyforgood/pet-rescue.git
```

Create a new `config/application.yml` file from the `config/application.example.yml`:
```
cp config/application.example.yml config/application.yml
```

Update your `config/application.yml` by replacing the places that say REPLACE_ME.

Run the setup script to prepare DB and assets
```sh
bin/setup
```

To run the app locally, use:
```
bin/dev
```

## Accessing Roles

You can use the following login credentials to access the following roles:

Adopter
- email: `adopter1@example.com`
- password: `123456`

Staff
- email: `staff@example.com`
- password: `123456`

You are also able to register an account.

## Subdomain Setup

The app will work OK with no subdomains, but to really test out the multi-tenant capabilities, you will need to configure subdomains. Every `Organization` has a subdomain field, and that Org will be accessible via `ApplicationController#current_tenant`.

To configure your local dev env to test subdomains, you will need to [edit your `/etc/hosts` file](https://linuxize.com/post/how-to-edit-your-hosts-file/)

Add the following line:

```text
127.0.0.1  pet-rescue.local alta.pet-rescue.local rubyforgood.pet-rescue.local
```
This will map the two seed Orgs with the correct subdomains

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

# 💅 Linting 

We use [standard](https://github.com/standardrb/standard) for linting. It provides a command for auto-fixing errors:

```sh
rails standard:fix
```

# 🔨 Tools

This [google sheets](https://docs.google.com/spreadsheets/d/1kPDeLicDu1IFkjWEXrWpwT36jtvoMVopEBiX-5L-r1A/edit?usp=sharing) contains a list of tools, their purposes, and who has access to grant permissions.

# 📖 About

## Ruby for Good
Pet Rescue is one of many projects initiated and run by Ruby for Good. You can find out more about Ruby for Good at https://rubyforgood.org

## Pet Rescue Adoption Sites
[Baja Pet Rescue](https://www.bajapetrescue.com)

---

# 📚Knowledge Base

## Preparation Work (Before code)
These are just some of the documents put together before writing any code:
* Slide deck to pitch idea to client: [here](https://docs.google.com/presentation/d/1d4gjzADk7BcxmQEVZlesheGUen9d1E3RzrVvskMhVxo/edit?usp=sharing)
* Figma site design: [here](https://www.figma.com/file/x3iM31l8csY7mT0VwKykhT/BPR---Wireframes---Ami?node-id=530186%3A154&t=mgRlseVd2LTKPX4o-1)
* Model association diagram: [here](https://lucid.app/lucidchart/a915c03c-3c09-454d-837b-f3d2768f5722/edit?viewport_loc=-25%2C-973%2C3565%2C2341%2C0_0&invitationId=inv_85cf2967-7b33-4030-903f-9655e767cbbf)

