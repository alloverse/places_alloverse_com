defmodule PlacesAlloverseCom.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias PlacesAlloverseCom.Repo

  alias PlacesAlloverseCom.Accounts.{User, Credential, UserToken, UserNotifier}

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    User
      |> Repo.all()
      |> Repo.preload(:credential)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    User
      |> Repo.get!(id)
      |> Repo.preload(:credential)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # def create_user(attrs \\ %{}) do
  #   %User{}
  #   |> User.changeset(attrs)
  #   |> Ecto.Changeset.cast_assoc(:credential, with: &Credential.changeset/2)
  #   |> Repo.insert()
  # end

  def register_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:credential, with: &Credential.registration_changeset/2)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:credential, with: &Credential.changeset/2)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  # alias PlacesAlloverseCom.Accounts.Credential

  @doc """
  Returns the list of credentials.

  ## Examples

      iex> list_credentials()
      [%Credential{}, ...]

  """
  def list_credentials do
    Repo.all(Credential)
  end

  @doc """
  Gets a single credential.

  Raises `Ecto.NoResultsError` if the Credential does not exist.

  ## Examples

      iex> get_credential!(123)
      %Credential{}

      iex> get_credential!(456)
      ** (Ecto.NoResultsError)

  """
  def get_credential!(id), do: Repo.get!(Credential, id)

  @doc """
  Creates a credential.

  ## Examples

      iex> create_credential(%{field: value})
      {:ok, %Credential{}}

      iex> create_credential(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_credential(attrs \\ %{}) do
    %Credential{}
    |> Credential.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a credential.

  ## Examples

      iex> update_credential(credential, %{field: new_value})
      {:ok, %Credential{}}

      iex> update_credential(credential, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_credential(%Credential{} = credential, attrs) do
    credential
    |> Credential.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Credential.

  ## Examples

      iex> delete_credential(credential)
      {:ok, %Credential{}}

      iex> delete_credential(credential)
      {:error, %Ecto.Changeset{}}

  """
  def delete_credential(%Credential{} = credential) do
    Repo.delete(credential)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking credential changes.

  ## Examples

      iex> change_credential(credential)
      %Ecto.Changeset{source: %Credential{}}

  """

  def authenticate_by_email_password(email, _password) do
    query =
      from u in User,
        inner_join: c in assoc(u, :credential),
        where: c.email == ^email

    case Repo.one(query) do
      %User{} = user -> {:ok, user}
      nil -> {:error, :unauthorized}
    end
  end


  def change_credential(%Credential{} = credential) do
    Credential.changeset(credential, %{})
  end

  def get_credential_by_email(email) when is_binary(email) do
    Repo.get_by(Credential, email: email)
  end

  def get_user_by_email(email) when is_binary(email) do
    credential = Repo.get_by(Credential, email: email) |> Repo.preload(:user)
    user = credential.user
  end

  def get_user_by_email_and_password(email, password) when is_binary(email) and is_binary(password) do
    credential = Repo.get_by(Credential, email: email) |> Repo.preload(:user)
    if Credential.valid_password?(credential, password), do: credential.user
  end


  ## Session

  @doc """
  Generates a session token.
  """
  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

   @doc """
  Gets the user with the given signed token.
  """
  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_user_session_token(token) do
    Repo.delete_all(UserToken.token_and_context_query(token, "session"))
    :ok
  end

  ## Settings

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user e-mail.
  ## Examples
      iex> change_user_email(user)
      %Ecto.Changeset{data: %User{}}
  """
  def change_user_email(user, attrs \\ %{}) do
    user1 = Repo.preload(user, :credential)
    Credential.email_changeset(user1.credential, attrs)
  end

  @doc """
  Emulates that the e-mail will change without actually changing
  it in the database.
  ## Examples
      iex> apply_user_email(user, "valid password", %{email: ...})
      {:ok, %User{}}
      iex> apply_user_email(user, "invalid password", %{email: ...})
      {:error, %Ecto.Changeset{}}
  """
  def apply_user_email(user, password, credential_attrs) do
    user1 = Repo.preload(user, :credential)
    user1.credential
    |> Credential.email_changeset(credential_attrs)
    |> Credential.validate_current_password(password)
    |> Ecto.Changeset.apply_action(:update)
  end

  @doc """
  Updates the user e-mail in token.
  If the token matches, the user email is updated and the token is deleted.
  The confirmed_at date is also updated to the current time.
  """
  def update_user_email(user, token) do
    user1 = Repo.preload(user, :credential)
    context = "change:#{user1.credential.email}"

    with {:ok, query} <- UserToken.verify_change_email_token_query(token, context),
         %UserToken{sent_to: email} <- Repo.one(query),
         {:ok, _} <- Repo.transaction(user_email_multi(user1, email, context)) do
      :ok
    else
      error ->
        IO.puts("error update_user_email")
        IO.inspect(error)
        :error
    end
  end

  defp user_email_multi(user, email, context) do
    changeset = user.credential |> Credential.email_changeset(%{email: email}) |> Credential.confirm_changeset()

    Ecto.Multi.new()
    |> Ecto.Multi.update(:credential, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, [context]))
  end

  @doc """
  Delivers the update e-mail instructions to the given user.
  ## Examples
      iex> deliver_update_email_instructions(user, current_email, &Routes.user_update_email_url(conn, :edit, &1))
      {:ok, %{to: ..., body: ...}}
  """
  def deliver_update_email_instructions(%User{} = user, current_email, new_email, update_email_url_fun)
      when is_function(update_email_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_email_token(user, "change:#{current_email}", new_email)

    Repo.insert!(user_token)
    UserNotifier.deliver_update_email_instructions(new_email, update_email_url_fun.(encoded_token))
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user password.
  ## Examples
      iex> change_user_password(user)
      %Ecto.Changeset{data: %User{}}
  """
  def change_user_password(user1, attrs \\ %{}) do
    user = Repo.preload(user1, :credential)
    Credential.password_changeset(user.credential, attrs)
  end

  @doc """
  Updates the user password.
  ## Examples
      iex> update_user_password(user, "valid password", %{password: ...})
      {:ok, %User{}}
      iex> update_user_password(user, "invalid password", %{password: ...})
      {:error, %Ecto.Changeset{}}
  """
  def update_user_password(user1, password, credential_attrs) do
    user = Repo.preload(user1, :credential)
    changeset =
      user.credential
      |> Credential.password_changeset(credential_attrs)
      |> Credential.validate_current_password(password)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:credential, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{credential: credential}} -> {:ok, credential}
      {:error, :credential, changeset, _} -> {:error, changeset}
    end
  end

  ## Confirmation

  @doc """
  Delivers the confirmation e-mail instructions to the given user.
  ## Examples
      iex> deliver_user_confirmation_instructions(user, &Routes.user_confirmation_url(conn, :confirm, &1))
      {:ok, %{to: ..., body: ...}}
      iex> deliver_user_confirmation_instructions(confirmed_user, &Routes.user_confirmation_url(conn, :confirm, &1))
      {:error, :already_confirmed}
  """
  def deliver_user_confirmation_instructions(%User{} = user, confirmation_url_fun)
      when is_function(confirmation_url_fun, 1) do
    user = Repo.preload(user, :credential)
    if user.credential.confirmed_at do
      {:error, :already_confirmed}
    else
      {encoded_token, user_token} = UserToken.build_email_token(user, "confirm")
      Repo.insert!(user_token)
      UserNotifier.deliver_confirmation_instructions(user, confirmation_url_fun.(encoded_token))
    end
  end

  @doc """
  Confirms a user by the given token.
  If the token matches, the user account is marked as confirmed
  and the token is deleted.
  """
  def confirm_user(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "confirm"),
        %User{} = user0 <- Repo.one(query),
        %User{} = user <- Repo.preload(user0, :credential),
        {:ok, %{credential: credential}} <- Repo.transaction(confirm_user_multi(user)) do
      {:ok, credential}
    else
      _ -> :error
    end
  end

  defp confirm_user_multi(user) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:credential, Credential.confirm_changeset(user.credential))
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, ["confirm"]))
  end

  ## Reset password

  @doc """
  Delivers the reset password e-mail to the given user.
  ## Examples
      iex> deliver_user_reset_password_instructions(user, &Routes.user_reset_password_url(conn, :edit, &1))
      {:ok, %{to: ..., body: ...}}
  """
  def deliver_user_reset_password_instructions(%User{} = user, reset_password_url_fun)
      when is_function(reset_password_url_fun, 1) do
    user1 = Repo.preload(user, :credential)
    {encoded_token, user_token} = UserToken.build_email_token(user, "reset_password", user1.credential.email)
    Repo.insert!(user_token)
    UserNotifier.deliver_reset_password_instructions(user1, reset_password_url_fun.(encoded_token))
  end

  @doc """
  Gets the user by reset password token.
  ## Examples
      iex> get_user_by_reset_password_token("validtoken")
      %User{}
      iex> get_user_by_reset_password_token("invalidtoken")
      nil
  """
  def get_user_by_reset_password_token(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "reset_password"),
         %User{} = user <- Repo.one(query) do
      user
    else
      _ -> nil
    end
  end

  @doc """
  Resets the user password.
  ## Examples
      iex> reset_user_password(user, %{password: "new long password", password_confirmation: "new long password"})
      {:ok, %User{}}
      iex> reset_user_password(user, %{password: "valid", password_confirmation: "not the same"})
      {:error, %Ecto.Changeset{}}
  """
  def reset_user_password(user, attrs) do
    user1 = Repo.preload(user, :credential)
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, Credential.password_changeset(user1.credential, attrs))
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

end
