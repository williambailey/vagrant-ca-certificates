require 'bundler/gem_tasks'

# Override rubygem_push to push to rubygems.dev server when doing `rake release`
module Bundler
        class GemHelper
                def rubygem_push(path)
                        sh("git push upstream --tags")
                        sh("stickler push --debug --server http://rubygems.dev.bloomberg.com #{path}")
                        Bundler.ui.confirm "Pushed #{name} #{version} to rubygems.dev.bloomberg.com."
                end
        end
end
