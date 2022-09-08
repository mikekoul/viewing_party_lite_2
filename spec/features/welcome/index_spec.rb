require 'rails_helper'

RSpec.describe 'landing page' do
  describe '#index' do
    it 'displays the title of the application' do
 
      visit '/'

      expect(page).to have_content('Viewing Party Lite')
    end

    it 'has a link back to the landing page' do

      visit '/'

      expect(page).to have_link('Home')

      click_link('Home')
    
      expect(current_path).to eq('/')
    end

    it 'has button to create a new user' do

      visit '/'

      expect(page).to have_button('Create New User')
    end
    
    it 'click button to redirect to new user registration form' do

      visit '/'

      click_button('Create New User')

      expect(current_path).to eq('/register')
    end

    it 'displays all exisiting users by email address' do
      user_1 = User.create!(name: 'Cindy Lou', email: 'cidlou@gmail.com', password: "test123")
      user_2 = User.create!(name: 'David Smith', email: 'daves@gmail.com', password: "test123")
      user_3 = User.create!(name: 'Mary Jones', email: 'maryjonesu@gmail.com', password: "test123")

      visit '/'

      within "#users0" do
        expect(page).to have_content("cidlou@gmail.com's Dashboard")
        expect(page).to_not have_content("daves@gmail.com's Dashboard")
      end

      within "#users1" do
        expect(page).to have_content("daves@gmail.com's Dashboard")
        expect(page).to_not have_content("maryjonesu@gmail.com's Dashboard")
      end

      within "#users2" do
        expect(page).to have_content("maryjonesu@gmail.com's Dashboard")
        expect(page).to_not have_content("cidlou@gmail.com's Dashboard")
      end
    end
  end

  describe '#user log_in happy path' do
    it 'has link to log in as an existing user' do
      user = User.create!(name: 'Mike Smith', email: 'mike@gmail.com', password: "test123")

      visit '/'

      expect(page).to have_link('Log in as an existing user')

      click_link('Log in as an existing user')

      expect(current_path).to eq(login_path)

      fill_in :email, with: 'mike@gmail.com'
      fill_in :password, with: 'test123'

      click_on('Log In')

      expect(current_path).to eq(users_path(user.id))
      expect(page).to have_content("Welcome, #{user.email}")
    end
  end

  describe "#log_in sad_path" do
    it 'should fail to log in if email credentials are incorrect' do
      user = User.create!(name: 'Mike Smith', email: 'mike@gmail.com', password: "test123")

      visit '/'

      click_link('Log in as an existing user')

      expect(current_path).to eq(login_path)

      fill_in :email, with: 'mikegmail.com'
      fill_in :password, with: 'test123'

      click_on('Log In')

      expect(current_path).to eq(login_path)
      expect(page).to have_content("Invalid Credentials")
    end

    it 'should fail to log in if password credentials are incorrect' do
      user = User.create!(name: 'Mike Smith', email: 'mike@gmail.com', password: "test123")

      visit '/'

      click_link('Log in as an existing user')

      expect(current_path).to eq(login_path)

      fill_in :email, with: 'mikegmail.com'
      fill_in :password, with: 'test'

      click_on('Log In')

      expect(current_path).to eq(login_path)
      expect(page).to have_content("Invalid Credentials")
    end
  end

  describe '#logged into session user functions root page' do
    it 'when logged into a session I no longer see a link to long in or create an account but I do see a link to log out' do
      user = User.create!(name: 'Mike Smith', email: 'mike@gmail.com', password: "test123")
      visit root_path
      click_link('Log in as an existing user')
      fill_in :email, with: 'mike@gmail.com'
      fill_in :password, with: 'test123'
      click_on('Log In')

      expect(page).to have_content("You are logged in")
      expect(page).to_not have_button('Create New User')
      expect(page).to_not have_link('Log in as an existing user')
    end

    it 'displays button to log out when session successful, click button to log out and see create new user and log in link have returned' do
      user = User.create!(name: 'Mike Smith', email: 'mike@gmail.com', password: "test123")
      visit root_path
      click_link('Log in as an existing user')
      fill_in :email, with: 'mike@gmail.com'
      fill_in :password, with: 'test123'
      click_on('Log In')

      expect(page).to have_button('Log Out')

      click_button("Log Out")

      expect(current_path).to eq(root_path)
      expect(page).to have_button('Create New User')
      expect(page).to have_link('Log in as an existing user')
      expect(page).to_not have_content("You are logged in")
    end
  end

  describe '#authorization' do
      it 'As a visitor I do not see the section for exisiting users' do

      visit root_path

      expect(page).to have_button('Create New User')
      expect(page).to have_link('Log in as an existing user')
      expect(page).to have_content('Log in or Register to experience Viewing Party Lite')
      expect(page).to_not have_content("You are logged in")
      expect(page).to_not have_content("Exisiting Users")
    end

    it 'As a registered visitor I see the section for exisiting users' do
      
      user_1 = User.create!(name: 'Cindy Lou', email: 'cidlou@gmail.com', password: "test123")
      user_2 = User.create!(name: 'David Smith', email: 'daves@gmail.com', password: "test123")
      user_3 = User.create!(name: 'Mary Jones', email: 'maryjonesu@gmail.com', password: "test123")
      user = User.create!(name: 'Mike Smith', email: 'mike@gmail.com', password: "test123")
      visit root_path
      click_link('Log in as an existing user')
      fill_in :email, with: 'mike@gmail.com'
      fill_in :password, with: 'test123'
      click_on('Log In')
      visit root_path

      expect(page).to have_content('Exisiting Users')

      within "#users0" do
        expect(page).to have_content("cidlou@gmail.com's Dashboard")
        expect(page).to_not have_content("daves@gmail.com's Dashboard")
      end

      within "#users1" do
        expect(page).to have_content("daves@gmail.com's Dashboard")
        expect(page).to_not have_content("maryjonesu@gmail.com's Dashboard")
      end

      within "#users2" do
        expect(page).to have_content("maryjonesu@gmail.com's Dashboard")
        expect(page).to_not have_content("cidlou@gmail.com's Dashboard")
      end
    end
  end
end