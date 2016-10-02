# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    # Each returned movie will be a hash representing one row of the movies_table
    # The keys will be the table headers and the values will be the row contents.
    # Entries can be directly to the database with ActiveRecord methods
    # Add the necessary Active Record call(s) to populate the database.
    # Check if movie is in the db, if not then add movie
    if ( ! Movie.find_by_title(movie[:title]))
        Movie.create!(movie)
    end
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
  # First, uncheck all ratings
  all_ratings = %w(G PG PG-13 NC-17 R)
  all_ratings.each do |rating|
    uncheck "ratings\[#{rating}\]"
  end
  # Next, check the desired ratings
  arg1.split(', ').each do |rating|
    check "ratings\[#{rating}\]"
  end
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
  # Check if desired check boxes are checked
  all_ratings = %w(G PG PG-13 NC-17 R)
  arg1.split(', ').each do |rating|
    page.has_checked_field? "ratings\[#{rating}\]"
    all_ratings.delete(rating) # delete specified ratings from all ratings
  end
  # Check if all other check boxes are not checked
  all_ratings.each do |rating|
    page.has_unchecked_field? "ratings\[#{rating}\]"
  end
end

Then /^I should see all of the movies$/ do
    all('tr').count == Movie.count # True if number of table rows equals number of rows in model
end



