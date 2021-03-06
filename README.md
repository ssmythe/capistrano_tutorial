Capistrano Tutorial
-------------------

This tutorial is a very simple introduction to the basic concepts of Capistrano.

    This tutorial works with Ruby 2.3.3 and Capistrano 2.15.5

### What is Capistrano?

Capistrano is a super easy tool that essentially remotely executes commands through SSH.

Capistrano is a stand-alone Ruby Gem (think optional utility) that follows an instruction file (called the "Capfile")
that in turn calls Ruby libraries.

### Vagrant Environment Setup

Download and install...
-   VirtualBox from: <https://www.virtualbox.org/wiki/Downloads?replytocom=98578>
-   Vagrant from: <https://www.vagrantup.com/downloads.html>

If you're on MacOS, please download and install...
-   Xcode from: the Apple app store
-   Then, in a terminal, type "sudo xcodebuild -license accept"
-   Brew from: <https://brew.sh/>
-   Then, in a terminal, type "brew install gnupg2", "brew install wget", and "brew update".

Next, we'll clone this project and launch Vagrant in a shell session:

    git clone https://github.com/ssmythe/capistrano_tutorial.git
    cd capistrano_tutorial
    vagrant up
    vagrant ssh captut

Now you're all set to go!

Note: If you want to use a later version of ruby and capistrano, replace the last shell line above with:

    vagrant ssh captut233

### How do I know Capistrano is set up right?

Check Ruby returns a version

    [vagrant@captut ~]$ ruby --version
    ruby 1.8.7 (2013-06-27 patchlevel 374) [x86_64-linux]
    [vagrant@captut ~]$ 


Check Capistrano returns a version

    [vagrant@captut ~]$ cap --version
    Capistrano v2.6.0
    [vagrant@captut ~]$ 

### Simple Capistrano Recipe

Capistrano recipes have three basic parts

-   Configuration
-   Server/Role list
-   Tasks

Let's look at a very simple recipe (default name "Capfile". If you want
to call it something else, you can use "cap -f capfilename.cap". The
".cap" extension is standard when you have lots of different recipe
files together.)

    namespace :hello do
      task :default do
        puts "Hello world"
      end
    end

To run this on the command line, just run "cap hello", and the output
should look like:

    [vagrant@captut ~]$ cap hello
      * executing `hello'
    Hello world
    [vagrant@captut ~]$ 

If you edit the Capfile and have it look like this:

    namespace :hello do
      task :default do
        puts "Hello world"
      end
    
      task :there do
        puts "Hello there"
      end
    end

You can run "cap hello:there", and the output should look like:

    [vagrant@captut ~]$ cap hello:there
       * executing `hello:there' 
    Hello there
    [vagrant@captut ~]$ 

So what's going on here? The Capfile is written in Ruby, so if you're
familiar with it, the block notation of do/end will be very familiar. I
won't go into the technical description of what Ruby's doing behind the scenes.
I'll just keep it simple as, for now, as if this were a simple,
stand-alone deploy automation language.

The "namespace" block keeps all the tasks in one nice neat section that
we refer to by the block symbol, in this case ":hello".

"task" is how we identify a unit of work. You'll notice a ":default"
task. This is what gets run if you don't specify a task.

You could run "cap hello:default" and get the same first output.

If you ever want to see what tasks are in a recipe, just run "cap -vT"
to get a list. It looks like:

    [vagrant@captut ~]$ cap -vT
    cap hello       # 
    cap hello:there # 
    cap invoke      # Invoke a single command on the remote servers.
    cap shell       # Begin an interactive Capistrano session.
    
    Extended help may be available for these tasks.
     Type cap -e taskname' to view it. 
    [vagrant@captut ~]$

The top two lines are the most important. We won't be using the other
stuff.

You'll notice we're using "puts" to output a message between quotes.
That's a great way to put important information in the output to help
debug and keep track of what's going on.

### Passing things in on the command line

Any time you want to pass along information to Capistrano from the
command line, you just use "-s key=value". Let's go back to our simple
example and add a simple example:

    namespace :hello do
      task :default do
        puts "Hello world"
      end
    
      task :there do
        puts "Hello there, #{myname}!"
      end
    end

Let's look at some sample output:

    [vagrant@captut ~]$ cap -s myname=Steve hello:there
       * executing hello:there' 
    Hello there, Steve!
    [vagrant@captut ~]$

You see how we used "\#{myname}" to get the value of myname? It's that
easy.

Now. What happens if you try running the script now without passing in
the variable?

    [vagrant@captut ~]$ cap hello:there
      * executing `hello:there'
    /home/vagrant/.rvm/gems/ruby-1.8.7-p374/gems/capistrano-2.6.0/lib/capistrano/configuration/namespaces.rb:188:in `method_missing': undefined local variable or method `myname' for #<Capistrano::Configuration::Namespaces::Namespace:0x7f773fdc4b88> (NameError)
    	from Capfile:7:in `load'
    	from /home/vagrant/.rvm/gems/ruby-1.8.7-p374/gems/capistrano-2.6.0/lib/capistrano/configuration/execution.rb:139:in `instance_eval'
    	from /home/vagrant/.rvm/gems/ruby-1.8.7-p374/gems/capistrano-2.6.0/lib/capistrano/configuration/execution.rb:139:in `invoke_task_directly_without_callbacks'
    	from /home/vagrant/.rvm/gems/ruby-1.8.7-p374/gems/capistrano-2.6.0/lib/capistrano/configuration/callbacks.rb:27:in `invoke_task_directly'
    	from /home/vagrant/.rvm/gems/ruby-1.8.7-p374/gems/capistrano-2.6.0/lib/capistrano/configuration/execution.rb:89:in `execute_task'
    	from /home/vagrant/.rvm/gems/ruby-1.8.7-p374/gems/capistrano-2.6.0/lib/capistrano/configuration/execution.rb:101:in `find_and_execute_task'
    	from /home/vagrant/.rvm/gems/ruby-1.8.7-p374/gems/capistrano-2.6.0/lib/capistrano/cli/execute.rb:46:in `execute_requested_actions_without_help'
    	from /home/vagrant/.rvm/gems/ruby-1.8.7-p374/gems/capistrano-2.6.0/lib/capistrano/cli/execute.rb:45:in `each'
    	from /home/vagrant/.rvm/gems/ruby-1.8.7-p374/gems/capistrano-2.6.0/lib/capistrano/cli/execute.rb:45:in `execute_requested_actions_without_help'
    	from /home/vagrant/.rvm/gems/ruby-1.8.7-p374/gems/capistrano-2.6.0/lib/capistrano/cli/help.rb:19:in `execute_requested_actions'
    	from /home/vagrant/.rvm/gems/ruby-1.8.7-p374/gems/capistrano-2.6.0/lib/capistrano/cli/execute.rb:34:in `execute!'
    	from /home/vagrant/.rvm/gems/ruby-1.8.7-p374/gems/capistrano-2.6.0/lib/capistrano/cli/execute.rb:14:in `execute'
    	from /home/vagrant/.rvm/gems/ruby-1.8.7-p374/gems/capistrano-2.6.0/bin/cap:4
    	from /home/vagrant/.rvm/gems/ruby-1.8.7-p374/bin/cap:23:in `load'
    	from /home/vagrant/.rvm/gems/ruby-1.8.7-p374/bin/cap:23
    	from /home/vagrant/.rvm/gems/ruby-1.8.7-p374/bin/ruby_executable_hooks:24
    [vagrant@captut ~]$ 

Uh oh... It blew up. That's because we're trying to use a variable that
hasn't been defined. It's best to have defaults for anything you're
going to use like this. Let's update the script so it works both ways:

    set :myname, "you person you"
    
    namespace :hello do
      task :default do
        puts "Hello world"
      end
    
      task :there do
        puts "Hello there, #{myname}!"
      end
    end

See how we set the default value at the top? Easy, huh? Here's the
output when you run it both ways:

    [vagrant@captut ~]$ cap hello:there
       * executing hello:there' 
    Hello there, you person you!
    [vagrant@captut ~]$ cap -s myname=Steve hello:there
       * executing hello:there' 
    Hello there, Steve!
    [vagrant@captut ~]$

Note: keep in mind that there are two ways to inject variables into
Capistrano. "-S" (capital S) and "-s" (lower-case s). Capital "S" means
you set the variable before the recipes are loaded. Lower-case "s" means
set the variable after the recipes are loaded. It's important to use
"-s" (lower-case) if you're using the default values technique.
Otherwise, if you use "-S" (Capital "S"), you would set your variable,
the default would come along and blast right over the top of it, and you
wouldn't get the results you were lookin' for. Just keep that in mind.

### Running commands

Let's look at this simple recipe that has configuration, servers, and
tasks sections in it:

    # Configuration
    set :user, 'vagrant'
     
    # Servers
    server "localhost", :all
    
    # Tasks
    namespace :simple do
      task :default do
        run "uname -a"
      end
    end

When we run it, the output looks like:

    [vagrant@captut ~]$ cap simple
      * executing `simple'
      * executing "uname -a"
        servers: ["localhost"]
        [localhost] executing command
     ** [out :: localhost] Linux captut 2.6.32-696.30.1.el6.x86_64 #1 SMP Tue May 22 03:28:18 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
        command finished in 182ms
    [vagrant@captut ~]$

So let's see what's going on...

The configuration section defines the username to log into the server as.

The servers section has just the one server in it "localhost". Now
you'll want to use the fully qualified domain name (FQDN) of the server
(like capalpha), since that's the easiest to read. You
could use IP addresses, but ick. Very hard to read.

### Running multiple tasks

Now let's look at running multiple tasks in one shot:

    # Configuration
    set :user, 'vagrant'
    
    # Servers
    server "localhost", :all
    
    # Tasks
    namespace :simple do
      desc "Default action: hostname and current user"
      task :default do
        display_hostname
        display_current_user
      end
    
      desc "Display hostname"
      task :display_hostname do
        run "uname -n"
      end
    
      desc "Display current user"
      task :display_current_user do
        run "whoami"
      end
    end

Let's look at the tasks available to us in this recipe:

    [vagrant@captut ~]$ cap -vT
    cap invoke                      # Invoke a single command on the remote servers.
    cap shell                       # Begin an interactive Capistrano session.
    cap simple                      # Default action: hostname and current user
    cap simple:display_current_user # Display current user
    cap simple:display_hostname     # Display hostname
    
    Extended help may be available for these tasks.
     Type cap -e taskname' to view it. 
    [vagrant@captut ~]$

You can see three things in the "simple namespace": simple,
simple:display\_current\_user, and simple:display\_hostname. We want to
use descriptive names for our tasks.

Also, notice the "desc" part right before the "task" part in the recipe?
That's how you can explain what your task does.

Okay, you see in ":default" how we're calling two tasks:
"display\_hostname" and "display\_current\_user"? That's how you call
one task after another.

You can run each task individually, by name, or call them in a row.

### Running tasks only on certain role servers

Now let's say you wanna run tasks only on certain servers. Capistrano
uses roles for this. A role is a group of hosts with a name. This might
be all your web servers, app servers, or database servers, for example.

Let's see how this works:

    # Configuration
    set :user, 'vagrant'
    
    # Servers
    server "capalpha", :all, :agroup
    server "capbravo", :all, :bgroup
    
    # Tasks
    namespace :simple do
      desc "Default action: hostname and current user"
      task :default do
        display_hostname
        display_current_user
      end
    
      desc "Display hostname"
      task :display_hostname, :roles => [ :all ] do
        run "uname -n"
      end
    
      desc "Display current user"
      task :display_current_user, :roles => [ :agroup ] do
        run "whoami"
      end
    end

So let's run it and see what happens:

    [vagrant@captut ~]$ cap simple
      * executing `simple'
      * executing `simple:display_hostname'
      * executing "uname -n"
        servers: ["capalpha", "capbravo"]
        [capalpha] executing command
        [capbravo] executing command
     ** [out :: capalpha] capalpha
     ** [out :: capbravo] capbravo
        command finished in 201ms
      * executing `simple:display_current_user'
      * executing "whoami"
        servers: ["capalpha"]
        [capalpha] executing command
     ** [out :: capalpha] vagrant
        command finished in 38ms
    [vagrant@captut ~]$ 

Check that out! The ", :roles =&gt; :all" on the display\_hostname task
was run on both capalpha and capbravo servers, since they are both in the
":all" role.

Notice that "whoami" was only run on "capalpha", since ", :roles =&gt;
:agroup" was added to the display\_current\_user task. "capalpha" is the
only host in the "agroup" role.

Easy stuff, huh?

### Running stuff only in certain situations

Let's say you have to run a special command in a specific environment.
Let's say you want to do something special in the "qa" environment.

    set :env, "dev"
    
    namespace :conditional do
      task :default do
        run_everywhere
        if (env == "qa") 
          run_in_qa
        end
      end
    
      task :run_everywhere do
        puts "I'm running everywhere"
      end
    
      task :run_in_qa do
        puts "I'm only running in qa"
      end
    end

Let's run it with defaults and then run it setting "env=qa":

    [vagrant@captut ~]$ cap conditional
      * executing `conditional'
      * executing `conditional:run_everywhere'
    I'm running everywhere
    [vagrant@captut ~]$ cap -s env=qa conditional
      * executing `conditional'
      * executing `conditional:run_everywhere'
    I'm running everywhere
      * executing `conditional:run_in_qa'
    I'm only running in qa
    [vagrant@captut ~]$

### Cleanup

If you're all done exploring Capistrano, exit out of your vagrant ssh session, and then in the original shell session:

    vagrant destroy -f

That shuts down and destroys all vagrant VMs that were spun up for this tutorial.

### Wrapup

That wraps up the simple stuff with Capistrano. I hope you enjoyed
our romp through this exciting deployment automation tool.

Have a good one!
