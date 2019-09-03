guard :rspec, cmd: 'spring rspec' do
  watch(%r{^app/}) { 'spec/system' }
  watch(%r{^spec/}) { 'spec/system' }
  watch('config/routes.rb') { 'spec/system' }
end