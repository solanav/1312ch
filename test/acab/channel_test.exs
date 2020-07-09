defmodule Acab.ChannelTest do
  use Acab.DataCase

  alias Acab.Channel

  describe "boards" do
    alias Acab.Channel.Board

    @valid_attrs %{title: "some title", url: "some url"}
    @update_attrs %{title: "some updated title", url: "some updated url"}
    @invalid_attrs %{title: nil, url: nil}

    def board_fixture(attrs \\ %{}) do
      {:ok, board} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Channel.create_board()

      board
    end

    test "list_boards/0 returns all boards" do
      board = board_fixture()
      assert Channel.list_boards() == [board]
    end

    test "get_board!/1 returns the board with given id" do
      board = board_fixture()
      assert Channel.get_board!(board.id) == board
    end

    test "create_board/1 with valid data creates a board" do
      assert {:ok, %Board{} = board} = Channel.create_board(@valid_attrs)
      assert board.title == "some title"
      assert board.url == "some url"
    end

    test "create_board/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Channel.create_board(@invalid_attrs)
    end

    test "update_board/2 with valid data updates the board" do
      board = board_fixture()
      assert {:ok, %Board{} = board} = Channel.update_board(board, @update_attrs)
      assert board.title == "some updated title"
      assert board.url == "some updated url"
    end

    test "update_board/2 with invalid data returns error changeset" do
      board = board_fixture()
      assert {:error, %Ecto.Changeset{}} = Channel.update_board(board, @invalid_attrs)
      assert board == Channel.get_board!(board.id)
    end

    test "delete_board/1 deletes the board" do
      board = board_fixture()
      assert {:ok, %Board{}} = Channel.delete_board(board)
      assert_raise Ecto.NoResultsError, fn -> Channel.get_board!(board.id) end
    end

    test "change_board/1 returns a board changeset" do
      board = board_fixture()
      assert %Ecto.Changeset{} = Channel.change_board(board)
    end
  end

  describe "threads" do
    alias Acab.Channel.Thread

    @valid_attrs %{author: "some author", body: "some body", title: "some title"}
    @update_attrs %{author: "some updated author", body: "some updated body", title: "some updated title"}
    @invalid_attrs %{author: nil, body: nil, title: nil}

    def thread_fixture(attrs \\ %{}) do
      {:ok, thread} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Channel.create_thread()

      thread
    end

    test "list_threads/0 returns all threads" do
      thread = thread_fixture()
      assert Channel.list_threads() == [thread]
    end

    test "get_thread!/1 returns the thread with given id" do
      thread = thread_fixture()
      assert Channel.get_thread!(thread.id) == thread
    end

    test "create_thread/1 with valid data creates a thread" do
      assert {:ok, %Thread{} = thread} = Channel.create_thread(@valid_attrs)
      assert thread.author == "some author"
      assert thread.body == "some body"
      assert thread.title == "some title"
    end

    test "create_thread/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Channel.create_thread(@invalid_attrs)
    end

    test "update_thread/2 with valid data updates the thread" do
      thread = thread_fixture()
      assert {:ok, %Thread{} = thread} = Channel.update_thread(thread, @update_attrs)
      assert thread.author == "some updated author"
      assert thread.body == "some updated body"
      assert thread.title == "some updated title"
    end

    test "update_thread/2 with invalid data returns error changeset" do
      thread = thread_fixture()
      assert {:error, %Ecto.Changeset{}} = Channel.update_thread(thread, @invalid_attrs)
      assert thread == Channel.get_thread!(thread.id)
    end

    test "delete_thread/1 deletes the thread" do
      thread = thread_fixture()
      assert {:ok, %Thread{}} = Channel.delete_thread(thread)
      assert_raise Ecto.NoResultsError, fn -> Channel.get_thread!(thread.id) end
    end

    test "change_thread/1 returns a thread changeset" do
      thread = thread_fixture()
      assert %Ecto.Changeset{} = Channel.change_thread(thread)
    end
  end

  describe "replies" do
    alias Acab.Channel.Reply

    @valid_attrs %{author: "some author", body: "some body"}
    @update_attrs %{author: "some updated author", body: "some updated body"}
    @invalid_attrs %{author: nil, body: nil}

    def reply_fixture(attrs \\ %{}) do
      {:ok, reply} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Channel.create_reply()

      reply
    end

    test "list_replies/0 returns all replies" do
      reply = reply_fixture()
      assert Channel.list_replies() == [reply]
    end

    test "get_reply!/1 returns the reply with given id" do
      reply = reply_fixture()
      assert Channel.get_reply!(reply.id) == reply
    end

    test "create_reply/1 with valid data creates a reply" do
      assert {:ok, %Reply{} = reply} = Channel.create_reply(@valid_attrs)
      assert reply.author == "some author"
      assert reply.body == "some body"
    end

    test "create_reply/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Channel.create_reply(@invalid_attrs)
    end

    test "update_reply/2 with valid data updates the reply" do
      reply = reply_fixture()
      assert {:ok, %Reply{} = reply} = Channel.update_reply(reply, @update_attrs)
      assert reply.author == "some updated author"
      assert reply.body == "some updated body"
    end

    test "update_reply/2 with invalid data returns error changeset" do
      reply = reply_fixture()
      assert {:error, %Ecto.Changeset{}} = Channel.update_reply(reply, @invalid_attrs)
      assert reply == Channel.get_reply!(reply.id)
    end

    test "delete_reply/1 deletes the reply" do
      reply = reply_fixture()
      assert {:ok, %Reply{}} = Channel.delete_reply(reply)
      assert_raise Ecto.NoResultsError, fn -> Channel.get_reply!(reply.id) end
    end

    test "change_reply/1 returns a reply changeset" do
      reply = reply_fixture()
      assert %Ecto.Changeset{} = Channel.change_reply(reply)
    end
  end
end
