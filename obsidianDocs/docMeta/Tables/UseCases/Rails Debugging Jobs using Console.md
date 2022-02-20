---
type: useCase
category: ["#rails"]
---

```ad-note
1. [[Open Rails Console with Docker]]
2. [[Open Rails Interactive Mode]]
3. Call the Job and use the perform_now method
```

```ad-example
Job File
~~~ruby
class Foo < ActiveJob::Base
  def perform(arg1)
    puts "Hello #{arg1}"
  end
end
~~~
Ruby Console
----------
~~~
Foo.perform_now('world')
~~~
```

