require 'fileutils'

Given("a file named {string} with:") do |path, content|
  base_path = File.dirname(path)
  FileUtils.mkdir_p base_path

  File.write(path, content)
end

When("I start the proxy server") do
  system('start_proxy')
end

Then("the file {string} should contain:") do |path, expected_content|
  actual_content = File.read(path)

  expect(actual_content).to include(expected_content)
end

Then("the file {string} should contain the following lines:") do |path, expected_lines_str|
  actual_content = File.read(path)

  expected_lines = expected_lines_str.split("\n")

  expected_lines.each do |line|
    expect(actual_content).to include(line.gsub('\s+', ''))
  end
end

Then("the file {string} should not contain:") do |path, expected_content|
  actual_content = File.read(path)

  expect(actual_content).not_to include(expected_content)
end