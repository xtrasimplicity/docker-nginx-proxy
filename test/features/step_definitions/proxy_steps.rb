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