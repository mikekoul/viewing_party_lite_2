require 'rails_helper'

RSpec.describe 'user registration page' do
   it 'can visit the register path' do
      visit register_path

      expect(current_path).to eq(register_path)
   end

   describe '#password_registration' do
      it 'has a form to register with name, email, password, and password confirmation'  do
         visit register_path

         fill_in 'user[name]', with: "Nancy"
         fill_in 'user[email]', with: "nancydrew@email.com"
         fill_in 'user[password]', with: "test123"
         fill_in 'user[password_confirmation]', with: "test123"

         click_button 'Create New User'

         user = User.last

         expect(current_path).to eq(user_path(user.id))
         expect(page).to have_content("Nancy's Dashboard")
         expect(page).to have_content("Welcome, #{user.email}")
      end
   end

   describe '#sad_path' do
      it 'stays in register page if user leaves name field blank and displays an error message' do

         visit register_path

         fill_in 'user[email]', with: "nancydrew@email.com"
         fill_in 'user[password]', with: "test123"
         fill_in 'user[password_confirmation]', with: "test123"

         click_button 'Create New User'

         expect(current_path).to eq("/register")
         expect(page).to have_content("Name can't be blank")
      end

      it 'stays in register page if user leaves email field blank and displays an error message' do

         visit register_path

         fill_in 'user[name]', with: "Nancy"
         fill_in 'user[password]', with: "test123"
         fill_in 'user[password_confirmation]', with: "test123"

         click_button 'Create New User'

         expect(current_path).to eq("/register")
         expect(page).to have_content("Email can't be blank")
      end

      it 'stays in register page if user leaves password field blank and displays an error message' do

         visit register_path

         fill_in 'user[name]', with: "Nancy"
         fill_in 'user[email]', with: "nancydrew@email.com"
         fill_in 'user[password_confirmation]', with: "test123"

         click_button 'Create New User'

         expect(current_path).to eq("/register")
         expect(page).to have_content("Password can't be blank")
      end

      it 'stays in register page if user leaves password confirmation field blank and displays an error message' do

         visit register_path

         fill_in 'user[name]', with: "Nancy"
         fill_in 'user[email]', with: "nancydrew@email.com"
         fill_in 'user[password]', with: "test123"

         click_button 'Create New User'

         expect(current_path).to eq("/register")
         expect(page).to have_content("Password confirmation doesn't match Password")
      end

      it 'stays in register page if the password and password confirmation field do not match and displays an error message' do

         visit register_path

         fill_in 'user[name]', with: "Nancy"
         fill_in 'user[email]', with: "nancydrew@email.com"
         fill_in 'user[password]', with: "test123"
         fill_in 'user[password_confirmation]', with: "test"

         click_button 'Create New User'

         expect(current_path).to eq("/register")
         expect(page).to have_content("Password confirmation doesn't match Password")
      end
   end
end