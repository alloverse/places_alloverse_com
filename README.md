# places_alloverse_com
A web site where user accounts can be created and managed, and from those accounts, places can be created and managed. Landing page for when opening the app without an URL.

---

# PlacesAlloverseCom

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

# Run with Docker

`docker build -t alloverse_dashboard .`

And then

`docker run --publish 4000:4000 --env DATABASE_URL=ecto://user:pass@<my_ip>/db_name --env SECRET_KEY_BASE="somethingSecret" --rm -it alloverse_dashboard`

## Using local database on Mac

Replace listen with listen = "*" in this file

`sudo pico /usr/local/var/postgres/postgresql.conf`

Add your ip address and trust in this file

`sudo pico /usr/local/var/postgres/pg_hba.conf`

Then restart postgress like this

`brew services restart postgres`


## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

