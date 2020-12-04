defmodule PlacesAlloverseComWeb.UserSettingsController do
  use PlacesAlloverseComWeb, :controller

  alias PlacesAlloverseCom.Accounts
  alias PlacesAlloverseComWeb.UserAuth

  plug :assign_email_and_password_changesets

  def edit(conn, _params) do
    render(conn, "edit.html")
  end

  def update_email(conn, %{"current_password" => password, "credential" => credential_params}) do
    user = conn.assigns.current_user
    user_with_credential = Accounts.get_user!(user.id)

    case Accounts.apply_user_email(user, password, credential_params) do
      {:ok, applied_credential} ->
        Accounts.deliver_update_email_instructions(
          user,
          user_with_credential.credential.email, #old email
          applied_credential.email, #new email
          &Routes.user_settings_url(conn, :confirm_email, &1)
        )

        conn
        |> put_flash(
          :info,
          "A link to confirm your e-mail change has been sent to the new address."
        )
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      {:error, changeset} ->
        render(conn, "edit.html", email_changeset: changeset)
    end
  end

  def confirm_email(conn, %{"token" => token}) do
    case Accounts.update_user_email(conn.assigns.current_user, token) do
      :ok ->
        conn
        |> put_flash(:info, "E-mail changed successfully.")
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      :error ->
        conn
        |> put_flash(:error, "Email change link is invalid or it has expired.")
        |> redirect(to: Routes.user_settings_path(conn, :edit))
    end
  end

  def update_password(conn, %{"current_password" => password, "credential" => credential_params}) do
    user = conn.assigns.current_user

    case Accounts.update_user_password(user, password, credential_params) do
      {:ok, credential} ->
        conn
        |> put_flash(:info, "Password updated successfully.")
        |> put_session(:user_return_to, Routes.user_settings_path(conn, :edit))
        |> UserAuth.login_user(user)
        {:error, changeset} ->
          render(conn, "edit.html", password_changeset: changeset)
      end
    end

    defp assign_email_and_password_changesets(conn, _opts) do
      user = conn.assigns.current_user

      conn
      |> assign(:email_changeset, Accounts.change_user_email(user))
      |> assign(:password_changeset, Accounts.change_user_password(user))
    end
end
