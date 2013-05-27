#!/usr/bin/env ruby


require 'nokogiri'

def generate_slideshow(doc, projects)
  doc.div.banner! do
    doc.div.slideshow! do
      projects.each do |name, category|
        doc.input( :type => 'button', :id => 'btnLeft', :class => 'ssbutton')
        category['projects'].each_with_index do |project,i|
          doc.div.slide( :id => "slide#{i}") do
            link = project['link'] || "#{category['link']}/#{project['name']}"
            doc.a( :href => link, :target => '_blank') do
              doc.img( :src => project['img'], :alt => project['alt'])
              doc.span project['name']
            end
          end
        end
      end
    end
  end
  doc
end

def generate_details(doc, projects)
  projects.each do |name, category|
    doc.section.projectType do
      doc.h1 do
        doc.a( :href => category['link'], :target => '_blank')
      end
      doc.dl do
        category['projects'].each do |project|
          link = project['link'] || "#{category['link']}/#{project['name']}"
          doc.a( :href => link, :target => '_blank') do
            dt do
              h2 project['name'] 
            end
            doc.dd project['desc']
          end
        end
      end
    end
  end
  main_doc
end

def generate(main_doc, projects)
  Nokogiri::HTML::Builder.with(main_doc) do |doc|
    doc.head do
      doc.meta( :charset => 'utf-8')
      doc.meta( 'http-equiv' => '"X-UA-Compatible', 'content' => "IE=edge,chrome=1")
      doc.title 'Criteo'
      doc.meta( :name => 'viewport', :content => 'width=device-width')

      doc.link( :rel => "stylesheet/less", :href => "css/main.less", :type => 'text/css')
      doc.link( :rel => "stylesheet/less", :href => "css/responsive.less", :type => 'text/css')
      doc.script( :src => "js/less-1.3.3.min.js", :type => "text/javascript")
      doc.script( :src => "js/vendor/modernizr-2.6.2.min.js")
    end
    doc.body do
      doc.nav do
        doc.div do
          home = 'Home'
          doc.a( :href => "http://criteo.github.io/") { 'Home' }
          doc.a( :href => "https://github.com/criteo", :target => '_blank') { 'Github Projects' }
        end
      end
      doc.header do
        doc.div.header_logo
      end
      doc.section.projectOverview! do
        generate_slideshow(doc, projects)
        doc.div.logo! do
          a( :href => "http://www.criteo.com/", :target => '_blank') { 'Criteo' }
        end
      end
      doc.section.projectDetails! do
        generate_details(doc, projects)
      end
      doc.footer "&copy; Criteo 2013"
      doc.script( :src => "js/jquery-1.7.2.min.js", :type => "text/javascript")
      doc.script( :src => "js/main.js", :type => "text/javascript")
    end
  end
  main_doc
end


opscode_projects = %w(mysql ntp chef-client chef-mongodb-mms-agent nagios
                     sql_server chef-monit).map do |p|
  { 'link' => "https://github.com/criteo-cookbooks/#{p}",
    'img' => 'img/logo_opscode.jpg',
    'alt' => 'opscode',
    'name' => p,
    'desc' => "Development repository for cookbook #{p}"
  }
                     end

projects = {
  'Criteo Projects' => {
    'link' => "https://github.com/criteo/",
    'projects' => [
      { 'link' => "https://github.com/criteo/criteo.github.com",
        'alt' => 'Criteo',
        'name' => 'criteo.github.com',
        'desc' => 'Front page Github for Criteo'
      }
    ]
  },
  'Chef Cookbooks' => {
    'link' => "https://github.com/criteo-cookbooks/",
    'projects' => opscode_projects
  },
  'Forked Projects' => {
    'link' => "https://github.com/criteo/",
    'projects' => [
      { 'link' => "https://github.com/criteo/metrics-net",
        'img' => "img/logo_metrics.png",
        'alt' => 'Metrics',
        'name' => 'Metrics',
        'desc' => "Capturing CLR and application-level metrics. So you know what's going on"
      }
    ]
  }
}


@doc = Nokogiri::HTML::DocumentFragment.parse ""
puts generate(@doc, projects).to_xhtml
