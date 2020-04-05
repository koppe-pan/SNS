# Sns

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## About Schema
0.schemas
  * user
    object :user do
      field :id, :id
      field :name, :string
      field :phone, :string
      field :password_hash, :string
      field :is_admin, :boolean
    end

    /* passwordの取得は不可能であり、取得する際はhash化されたpassword_hashとなる(passwordを取得しようとするとerrorとなる。) */

  * session
    object :token do
      field :token, :string
    end

    /* jwtのtokenを持つ。contextにこの情報が入ると、各種操作が可能になる。個別の事例は下記 */

1.query
  * {
      users{
        @userparams
      }
    }

    /* 全てのuser情報のうち、@someparamsに指定された要素を取得する。*/

  * {
      user(id: @int){
        @userparams
      }
    }

    /* idが@intのuserの、@userparamsに指定された要素を取得する。*/

  * {
      currentUser{
        @userparams
      }
    }

    /* 現在のアプリの利用者について、@userparamsに指定された要素を取得する。
       sessionによりログインしている必要あり。 */

2.mutation
  * mutation @CreateUser{
      createUser(name: @, phone: @, password: @, is_admin: _@){
        @userparams
      }
    }

    /* ユーザー登録を行い、@userparamsに指定された要素を取得する。
       sessionによりログインしている必要あり。 */

  * mutation @LoginUser{
      session(phone: @, password: @){
        @jwtToken
      }
    }

    /* ログインを行い、対象のjwtTokenを取得する。 */
