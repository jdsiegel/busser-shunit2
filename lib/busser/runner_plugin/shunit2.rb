# -*- encoding: utf-8 -*-
#
# Author:: Jeff Siegel (<jdsiegel@gmail.com>)
#
# Copyright (C) 2013, Jeff Siegel
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'busser/runner_plugin'

# A Busser runner plugin for Shunit2.
#
# @author Jeff Siegel <jdsiegel@gmail.com>
#
class Busser::RunnerPlugin::Shunit2 < Busser::RunnerPlugin::Base

  postinstall do
    tmp_root      = Pathname.new(Dir.mktmpdir("shunit2"))
    tarball_url   = "https://shunit2.googlecode.com/files/shunit2-2.1.6.tgz"
    tarball_file  = tmp_root.join("shunit2.tgz")
    extract_root  = tmp_root.join("shunit2")
    dest_path     = vendor_path("shunit2")

    empty_directory(extract_root)
    empty_directory(dest_path)

    get(tarball_url, tarball_file)
    inside(extract_root) do
      run!(%{gunzip -c "#{tarball_file}" | tar xf - --strip-components=1})
      run!(%{cp -f "#{extract_root}/src/shunit2" "#{dest_path}"})
    end
    remove_dir(tmp_root)

    inside(dest_path) do
      create_file("runner") do
        """
        #!/bin/bash
        . $1
        . $2
        """
      end
      chmod("runner", 0755)
    end
  end

  def test
    shunit2_file = vendor_path('shunit2').join('shunit2')
    runner       = vendor_path('shunit2').join('runner')
    Dir.glob("#{suite_path('shunit2')}/*_{test,spec}.{sh,bash}").each do |file|
      banner "[shunit2] #{File.basename(file)}"
      run!("#{runner} #{file} #{shunit2_file}")
    end
  end
end
