class SessionsController < Devise::SessionsController
    # prepend_before_action :verify_signed_out_user, only: :destroy
    def destroy
        # super
        current_user.update_column(:unique_session_id, nil)
        signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
        set_flash_message! :notice, :signed_out if signed_out
        yield if block_given?
        respond_to_on_destroy
    end
end
