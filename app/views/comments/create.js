@@ -0,0 +1,4 @@
<% if @comment.persisted? %>
  $("#<%= @comment.commentable_type.underscore %>-<%= @comment.commentable_id %>-comments")
    .find(".comments-list").append("<%= j render @comment %>")
  $('.new-comment #comment_body').val('')
<% end %>