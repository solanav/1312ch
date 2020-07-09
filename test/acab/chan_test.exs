defmodule Acab.ChanTest do
  use Acab.DataCase

  alias Acab.Chan

  describe "replies" do
    alias Acab.Chan.Reply

    @valid_attrs %{author: "some author", body: "some body"}
    @update_attrs %{author: "some updated author", body: "some updated body"}
    @invalid_attrs %{author: nil, body: nil}

    def reply_fixture(attrs \\ %{}) do
      {:ok, reply} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Chan.create_reply()

      reply
    end

    test "list_replies/0 returns all replies" do
      reply = reply_fixture()
      assert Chan.list_replies() == [reply]
    end

    test "get_reply!/1 returns the reply with given id" do
      reply = reply_fixture()
      assert Chan.get_reply!(reply.id) == reply
    end

    test "create_reply/1 with valid data creates a reply" do
      assert {:ok, %Reply{} = reply} = Chan.create_reply(@valid_attrs)
      assert reply.author == "some author"
      assert reply.body == "some body"
    end

    test "create_reply/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chan.create_reply(@invalid_attrs)
    end

    test "update_reply/2 with valid data updates the reply" do
      reply = reply_fixture()
      assert {:ok, %Reply{} = reply} = Chan.update_reply(reply, @update_attrs)
      assert reply.author == "some updated author"
      assert reply.body == "some updated body"
    end

    test "update_reply/2 with invalid data returns error changeset" do
      reply = reply_fixture()
      assert {:error, %Ecto.Changeset{}} = Chan.update_reply(reply, @invalid_attrs)
      assert reply == Chan.get_reply!(reply.id)
    end

    test "delete_reply/1 deletes the reply" do
      reply = reply_fixture()
      assert {:ok, %Reply{}} = Chan.delete_reply(reply)
      assert_raise Ecto.NoResultsError, fn -> Chan.get_reply!(reply.id) end
    end

    test "change_reply/1 returns a reply changeset" do
      reply = reply_fixture()
      assert %Ecto.Changeset{} = Chan.change_reply(reply)
    end
  end
end
