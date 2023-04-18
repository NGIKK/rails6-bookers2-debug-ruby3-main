class CommentsController < ApplicationController


def create

comment = current_user.Comments.new
comment.save


end


def destroy
end

end
