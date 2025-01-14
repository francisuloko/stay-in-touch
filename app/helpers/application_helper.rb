module ApplicationHelper
  def menu_link_to(link_text, link_path)
    class_name = current_page?(link_path) ? 'menu-item active' : 'menu-item'

    content_tag(:div, class: class_name) do
      link_to link_text, link_path
    end
  end

  def like_or_dislike_btn(post)
    like = Like.find_by(post: post, user: current_user)
    if like
      link_to('Dislike!', post_like_path(id: like.id, post_id: post.id), method: :delete)
    else
      link_to('Like!', post_likes_path(post_id: post.id), method: :post)
    end
  end

  def friendship_button(user)
    if current_user.friend? user
      link_to('Unfriend', reject_path(user_id: user.id), class: 'profile-link frienship_button', method: :delete,
                                                         remote: true)
    elsif current_user.pending_friends.include?(user)
      link_to('pending friendship ', user, class: 'profile-link frienship_button')
    elsif current_user.friend_requests.include?(user)
      link_to('Accept  ', invite_path(user_id: user.id), class: 'profile-link frienship_button', method: :put,
                                                         remote: true) +
        link_to('  Reject', reject_path(user_id: user.id), class: 'profile-link frienship_button', method: :delete,
                                                           remote: true)
    else
      link_to('Invite to friendship', invite_path(user_id: user.id), class: 'profile-link frienship_button',
                                                                     method: :post)
    end
  end
end
