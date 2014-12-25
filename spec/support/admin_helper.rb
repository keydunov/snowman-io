module AdminHelper
  def register_admin(password)
    visit "/unpacking"
    fill_in "password", with: password
    click_button "Set Admin Password"
    visit "/logout"
  end
end
