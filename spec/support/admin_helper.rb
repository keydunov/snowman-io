module AdminHelper
  def register_admin(password)
    visit "/unpacking"
    fill_in "password", with: password
    click_button "Set Admin Password"
    visit "/logout"
  end

  def register_admin_and_login(password)
    visit "/unpacking"
    fill_in "password", with: password
    click_button "Set Admin Password"
  end
end
