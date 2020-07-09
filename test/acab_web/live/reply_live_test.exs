defmodule AcabWeb.ReplyLiveTest do
  use AcabWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Acab.Channel

  @create_attrs %{author: "some author", body: "some body"}
  @update_attrs %{author: "some updated author", body: "some updated body"}
  @invalid_attrs %{author: nil, body: nil}

  defp fixture(:reply) do
    {:ok, reply} = Channel.create_reply(@create_attrs)
    reply
  end

  defp create_reply(_) do
    reply = fixture(:reply)
    %{reply: reply}
  end

  describe "Index" do
    setup [:create_reply]

    test "lists all replies", %{conn: conn, reply: reply} do
      {:ok, _index_live, html} = live(conn, Routes.reply_index_path(conn, :index))

      assert html =~ "Listing Replies"
      assert html =~ reply.author
    end

    test "saves new reply", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.reply_index_path(conn, :index))

      assert index_live |> element("a", "New Reply") |> render_click() =~
               "New Reply"

      assert_patch(index_live, Routes.reply_index_path(conn, :new))

      assert index_live
             |> form("#reply-form", reply: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#reply-form", reply: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.reply_index_path(conn, :index))

      assert html =~ "Reply created successfully"
      assert html =~ "some author"
    end

    test "updates reply in listing", %{conn: conn, reply: reply} do
      {:ok, index_live, _html} = live(conn, Routes.reply_index_path(conn, :index))

      assert index_live |> element("#reply-#{reply.id} a", "Edit") |> render_click() =~
               "Edit Reply"

      assert_patch(index_live, Routes.reply_index_path(conn, :edit, reply))

      assert index_live
             |> form("#reply-form", reply: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#reply-form", reply: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.reply_index_path(conn, :index))

      assert html =~ "Reply updated successfully"
      assert html =~ "some updated author"
    end

    test "deletes reply in listing", %{conn: conn, reply: reply} do
      {:ok, index_live, _html} = live(conn, Routes.reply_index_path(conn, :index))

      assert index_live |> element("#reply-#{reply.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#reply-#{reply.id}")
    end
  end

  describe "Show" do
    setup [:create_reply]

    test "displays reply", %{conn: conn, reply: reply} do
      {:ok, _show_live, html} = live(conn, Routes.reply_show_path(conn, :show, reply))

      assert html =~ "Show Reply"
      assert html =~ reply.author
    end

    test "updates reply within modal", %{conn: conn, reply: reply} do
      {:ok, show_live, _html} = live(conn, Routes.reply_show_path(conn, :show, reply))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Reply"

      assert_patch(show_live, Routes.reply_show_path(conn, :edit, reply))

      assert show_live
             |> form("#reply-form", reply: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#reply-form", reply: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.reply_show_path(conn, :show, reply))

      assert html =~ "Reply updated successfully"
      assert html =~ "some updated author"
    end
  end
end
