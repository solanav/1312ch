defmodule Acab.Channel do
  @moduledoc """
  The Channel context.
  """

  import Ecto.Query, warn: false
  alias Acab.Repo

  alias Acab.Channel.Board
  alias Acab.Channel.Reply
  alias Acab.Channel.Thread

  @doc """
  Returns the list of boards.

  ## Examples

      iex> list_boards()
      [%Board{}, ...]

  """
  def list_boards do
    Repo.all(Board)
  end

  @doc """
  Gets a single board.

  Raises `Ecto.NoResultsError` if the Board does not exist.

  ## Examples

      iex> get_board!(123)
      %Board{}

      iex> get_board!(456)
      ** (Ecto.NoResultsError)

  """
  def get_board!(id), do: Repo.get!(Board, id)

  @doc """
  Gets a single board by url.

  Raises `Ecto.NoResultsError` if the Board does not exist.

  ## Examples

      iex> get_board("b")
      %Board{}

      iex> get_board!("xaqe")
      nil

  """
  def get_board(url) do
    Enum.filter(list_boards(), fn b ->
      b.url == url
    end)
    |> Enum.at(0, nil)
  end

  @doc """
  Creates a board.

  ## Examples

      iex> create_board(%{field: value})
      {:ok, %Board{}}

      iex> create_board(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_board(attrs \\ %{}) do
    %Board{}
    |> Board.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a board.

  ## Examples

      iex> update_board(board, %{field: new_value})
      {:ok, %Board{}}

      iex> update_board(board, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_board(%Board{} = board, attrs) do
    board
    |> Board.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a board.

  ## Examples

      iex> delete_board(board)
      {:ok, %Board{}}

      iex> delete_board(board)
      {:error, %Ecto.Changeset{}}

  """
  def delete_board(%Board{} = board) do
    Repo.delete(board)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking board changes.

  ## Examples

      iex> change_board(board)
      %Ecto.Changeset{data: %Board{}}

  """
  def change_board(%Board{} = board, attrs \\ %{}) do
    Board.changeset(board, attrs)
  end

  alias Acab.Channel.Thread

  @doc """
  Returns the list of threads.

  ## Examples

      iex> list_threads()
      [%Thread{}, ...]

  """
  def list_threads do
    query = from Thread,
      order_by: [desc: :updated_at]

    Repo.all(query)
  end

  @doc """
  Returns the last thread.

  ## Examples

      iex> last_thread()
      %Thread{}

  """
  def last_thread do
    query = from Thread,
      order_by: :updated_at,
      limit: 1

    Repo.one(query)
  end

  @doc """
  Returns the number of threads.

  ## Examples

      iex> count_threads()
      3

  """
  def count_threads do
    query = from t in Thread,
      select: count(t.id)

    Repo.one(query)
  end

  @doc """
  Deletes oldest threads.

  ## Examples

      iex> delete_old_threads()
      3

  """
  def delete_old_threads(nthreads, max_threads) do
    Repo.delete!(last_thread())
    nthreads = nthreads - 1

    if nthreads > max_threads do
      delete_old_threads(nthreads, max_threads)
    end
  end

  def delete_old_threads do
    max_threads = Application.get_env(:acab, AcabWeb.Endpoint)[:max_threads]
    nthreads = count_threads()
    if nthreads > max_threads do
      delete_old_threads(nthreads, max_threads)
    end
  end

  @doc """
  Gets a single thread.

  Raises `Ecto.NoResultsError` if the Thread does not exist.

  ## Examples

      iex> get_thread!(123)
      %Thread{}

      iex> get_thread!(456)
      ** (Ecto.NoResultsError)

  """
  def get_thread!(id), do: Repo.get!(Thread, id)

  @doc """
  Gets a list of threads of a board.

  ## Examples

      iex> get_threads(2)
      [%Thread{}, %Thread{}, ]

      iex> get_threads(785)
      []

  """
  def get_threads(board_id) do
    Enum.filter(list_threads(), fn t ->
      t.board_id == board_id
    end)
    |> Enum.map(fn r -> Thread.parse_thread(r) end)
  end

  @doc """
  Creates a thread.

  ## Examples

      iex> create_thread(%{field: value})
      {:ok, %Thread{}}

      iex> create_thread(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_thread(attrs \\ %{}) do
    %Thread{}
    |> Thread.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a thread.

  ## Examples

      iex> update_thread(thread, %{field: new_value})
      {:ok, %Thread{}}

      iex> update_thread(thread, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_thread(%Thread{} = thread, attrs) do
    thread
    |> Thread.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a thread.

  ## Examples

      iex> delete_thread(thread)
      {:ok, %Thread{}}

      iex> delete_thread(thread)
      {:error, %Ecto.Changeset{}}

  """
  def delete_thread(%Thread{} = thread) do
    Repo.delete(thread)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking thread changes.

  ## Examples

      iex> change_thread(thread)
      %Ecto.Changeset{data: %Thread{}}

  """
  def change_thread(%Thread{} = thread, attrs \\ %{}) do
    Thread.changeset(thread, attrs)
  end

  alias Acab.Channel.Reply

  @doc """
  Returns the list of replies.

  ## Examples

      iex> list_replies()
      [%Reply{}, ...]

  """
  def list_replies do
    Repo.all(Reply)
  end

  @doc """
  Gets a single reply.

  Raises `Ecto.NoResultsError` if the Reply does not exist.

  ## Examples

      iex> get_reply!(123)
      %Reply{}

      iex> get_reply!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reply!(id), do: Repo.get!(Reply, id)

  @doc """
  Gets a single reply.

  Raises `Ecto.NoResultsError` if the Reply does not exist.

  ## Examples

      iex> count_replies(thread_id)
      3

  """
  def count_replies(thread_id) do
    query = from r in Reply,
      select: count(r.id),
      where: r.thread_id == ^thread_id

    Repo.one(query)
  end

  @doc """
  Gets a list of replies to a thread.

  Raises `Ecto.NoResultsError` if the Reply does not exist.

  ## Examples

      iex> get_replies(123)
      %Reply{}

      iex> get_replies(456)
      []

  """
  def get_replies(id) when is_integer(id) do
    Enum.filter(list_replies(), fn r ->
      r.thread_id == id
    end)
    |> Enum.map(fn r -> Reply.parse_reply(r) end)
  end

  @doc """
  Creates a reply.

  ## Examples

      iex> create_reply(%{field: value})
      {:ok, %Reply{}}

      iex> create_reply(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reply(attrs \\ %{}) do
    %Reply{}
    |> Reply.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a reply.

  ## Examples

      iex> update_reply(reply, %{field: new_value})
      {:ok, %Reply{}}

      iex> update_reply(reply, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reply(%Reply{} = reply, attrs) do
    reply
    |> Reply.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a reply.

  ## Examples

      iex> delete_reply(reply)
      {:ok, %Reply{}}

      iex> delete_reply(reply)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reply(%Reply{} = reply) do
    Repo.delete(reply)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reply changes.

  ## Examples

      iex> change_reply(reply)
      %Ecto.Changeset{data: %Reply{}}

  """
  def change_reply(%Reply{} = reply, attrs \\ %{}) do
    Reply.changeset(reply, attrs)
  end
end
