PUPPETMASTER = 'root@54.251.48.3'
SSH = 'ssh -i /cygdrive/z/Dropbox/ec2/velniukasEC2.pem -T -A'

task :deploy do
	sh "git push"
	sh "#{SSH} #{PUPPETMASTER} 'cd /etc/puppet && git pull'"
end

task :apply => [:deploy] do
	client = ENV['CLIENT']
	sh "#{SSH} #{client} 'sudo puppet agent --test'" do |ok, status|
		puts case status.exitstatus
		when 0 then "Client is up to date."
		when 1 then "Puppet couldn't compile the manifest."
		when 2 then "Puppet made changes."
		when 4 then "Puppet found errors."
		end
	end
end

task :noop => [:deploy] do
	client = ENV['CLIENT']
	sh "#{SSH} #{client} 'sudo puppet agent --test --noop'"
end