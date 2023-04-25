Exercise template
=================

This is a template structure for completing VHDL exercises in ELEC-E3540
Digital Microelectronics II. This repository is only for template development, to
make your own project out of this, use the tutorial below. _You can also use
these same steps with your own templates too, or with any git project._

### Repository structure:

- __Exercise\_instructions:__ pointer to a git submodule. Upon
  initializing, this directory will contain a git repository with exercise instructions.
- __simulations:__ directory for all simulaiton-related files, namely
    - do-files: QuestaSim scripts for automatic compiling of VHDL code and
      running simulation 
    - (optional) input and output files: these are sometimes required for
      your testbench for reading and writing information using VHDL textio 
    - QuestaSim files: these are automatically generated and should not be
      included in git version control (see .gitignore file)
- __vhdl:__ directory for your VHDL code and testbenches. _Remember, only 1 entity per file!_
- __.gitignore:__ file that specifies git to not track certain files and/or
  directories. Useful for keeping auto-generated trash out of the respository.

### How to start using the template:

Before starting, make sure you are certain about following:

* __name of your own course subgroup__ (check version.aalto.fi if you are not
  sure). In most cases this will be same as your git username.
* __name of your new project__

These two will be referred further as `<your-subgroup-name>` and
`<your-project-name>` accordingly.  __Do not use spaces or special
characters__, preferably only underscores or dashes, for example
`my-new-project_1`.

---

1. Clone the template repository under a new name.

```
git clone git@version.aalto.fi:elec-e3540-exec/exercise_template.git <your-project-name>
```

2. Remove the origin link and specify a new one within your own course
   subgroup.

```
cd <your-project-name>
git remote rm origin
git remote add origin git@version.aalto.fi:elec-e3540-exec/<your-subgroup-name>/<your-project-name>.git
```

3. Upload the project to a new origin you specified (this creates a new project
   in your subgroup.

```
git push --set-upstream origin master
```

4. Your new project is now visible online at
   version.aalto.fi/elec-e3540-exec/\<your-subgroup-name>

5. Intialize the instructions submodule

```
git submodule update --init Exercise_instructions
```

6. (optional) You can try using the QuestaSim do-file to automatically compile
   the OR-gate example and run the simulation _(assuming you are logged in to
   Vspace)_

```
cd simulations
use advms_17.1
vsim -do run_simulation.do
```

7. You can start developing! Make new entities and do-files if necessary. Don't
   forget to add, commit, and push your changes to the remote repository to
   save your progress. For example:

```
git add vhdl/multiplexer.vhd
git add simulaitions/run_multiplexer.do
git commit -m "added new version of multiplexer"
git push 
```

