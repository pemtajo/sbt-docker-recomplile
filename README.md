A minimal sbt project to reproduce the issue of code being recompiled on each docker step
even though the sources, artifacts, jdk and any residual caches are the same.

This reproduce the issue by running `sbt compile` and `sbt run` in two consecutive (but different)
steps in the docker build. 

### Issue

To reproduce the issue:
```bash
docker build .
```

The build output will show `Compiling 1 Scala source to /root/target/scala-2.12/classes`
in both `sbt compile` and `sbt run` stages, even though it gets previously compiled
in the first stage.

Uncomment the last two lines in `build.sbt` to enable debug output of the sbt process.
It shows the sources getting invalidated and running the recompilation.

```
[debug] Initial source changes: 
[debug]         removed:Set()
[debug]         added: Set()
[debug]         modified: Set()
[debug] Invalidated products: Set(/root/target/scala-2.12/classes/Main$.class, /root/target/scala-2.12/classes/Main.class)
[debug] External API changes: API Changes: Set()
[debug] Modified binary dependencies: Set()
[debug] Initial directly invalidated classes: Set()
[debug] 
[debug] Sources indirectly invalidated by:
[debug]         product: Set(/root/src/main/scala/Main.scala)
[debug]         binary dep: Set()
[debug]         external source: Set()
[debug] All sources are invalidated.
[debug] Recompiling all 1 sources: invalidated sources (1) exceeded 50.0% of all sources
```

### Solution

A workaround is proposed in https://github.com/sbt/sbt/issues/4168#issuecomment-417655678.

- Java 8: Setting -Dsbt.io.jdktimestamps=true when running SBT as recommended in
https://github.com/sbt/sbt/issues/4168#issuecomment-417655678 to workaround this issue.

- Newer: Follow recomendation in https://github.com/sbt/sbt/issues/4168#issuecomment-417658294
