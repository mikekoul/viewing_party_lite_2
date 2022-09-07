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
      user_1 = User.create!(name: 'Cindy Lou', email: 'cidlou@gmail.com')
      user_2 = User.create!(name: 'David Smith', email: 'daves@gmail.com')
      user_3 = User.create!(name: 'Mary Jones', email: 'maryjonesu@gmail.com')

      visit '/'

      within "#users0" do
        expect(page).to have_link("cidlou@gmail.com's Dashboard")
        expect(page).to_not have_link("daves@gmail.com's Dashboard")
      end

      within "#users1" do
        expect(page).to have_link("daves@gmail.com's Dashboard")
        expect(page).to_not have_link("maryjonesu@gmail.com's Dashboard")
      end

      within "#users2" do
        expect(page).to have_link("maryjonesu@gmail.com's Dashboard")
        expect(page).to_not have_link("cidlou@gmail.com's Dashboard")
      end
    end

    it 'each users email is a link to their specific dashboard' do
      user_1 = User.create!(name: 'Cindy Lou', email: 'cidlou@gmail.com')
      user_2 = User.create!(name: 'David Smith', email: 'daves@gmail.com')
      user_3 = User.create!(name: 'Mary Jones', email: 'maryjonesu@gmail.com')

      visit '/'
      
      within "#users0" do

        click_link("cidlou@gmail.com's Dashboard")

        expect(current_path).to eq(user_path(user_1.id))
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

      expect(current_path).to eq(user_path(user.id))
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
end