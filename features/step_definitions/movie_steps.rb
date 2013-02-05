# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create movie
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  flunk "Unimplemented"
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  ratings = rating_list.split(', ')
  ratings.each do |rating|
    uncheck ? uncheck("ratings_" + rating) : check("ratings_" + rating)
  end
end

When /^I (un)?check all ratings$/ do |uncheck|
  page.all('form input[@type="checkbox"]').each do |input|
    uncheck ? input.set(false) : input.set(true)
  end
end

When /^I refresh$/ do
  click_button "ratings_submit"
end

Then /^I should see no movies with the following ratings: (.*)$/ do |rating_list|
  ratings = "^(" + rating_list.gsub(/[,\s]/, ',' => '|') + ")$"
  all('table tbody tr td[2]').each { |rating| rating.text.should_not(match(ratings)) }
end

Then /^I should see all movies with the following ratings: (.*)$/ do |rating_list|
  ratings = rating_list.split(', ')
  listed = all('table tbody tr td[2]')

  listed.each { |l| ratings.include?(l.text).should == true}
  listed.length.should == Movie.find_all_by_rating(ratings).length
end

Then /^I should see all movies$/ do
  all('table tbody tr').count.should == Movie.all.count
end

Then /^The movie "(.*?)" should be listed before the movie "(.*?)"$/ do |first_movie, second_movie|
  page.body.index(first_movie).should < page.body.index(second_movie)
end
