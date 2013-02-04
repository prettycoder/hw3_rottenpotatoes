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

Then /^I should (not )?see movies with the following ratings: (.*)$/ do |negative, rating_list|
  ratings = "^(" + rating_list.gsub(/[,\s]/, ',' => '|') + ")$"
  listed_ratings = all('table tbody tr td[2]')
  listed_ratings.each do |rating|
    negative ? rating.text.should_not(match(ratings)) : rating.text.should(match(ratings))
  end
 end
