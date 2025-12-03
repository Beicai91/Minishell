# Name of the executable
NAME = minishell

# Compiler
CC = gcc 
# gcc -g -o so_long so_long.c
# Compiler flags
#CFLAGS = -Wall -Wextra -Werror -Wno-unused-but-set-variable -Wno-unused-const-variable -Wno-unused-parameter -Wno-unused-variable -Wno-sign-compare
CFLAGS := -Wall -Wextra -Werror -g -MMD -MP
# Include paths for header files
H_PATH := -I ./include -I /usr/local/Cellar/readline/8.2.1/include

# Library paths
LIB_PATH := -L ./lib/libft -L /usr/local/Cellar/readline/8.2.1/lib

# Libraries to link against, including the math library if needed
LDLIBS := -lft -lreadline

LFT = ./lib/libft/libft.a
# Source files
SRC = src/executing/builtin_utils1.c \
	  src/executing/builtin_utils2.c \
	  src/executing/builtin_utils3.c \
	  src/executing/builtins1.c \
	  src/executing/builtins2.c \
	  src/executing/builtins3.c \
	  src/executing/builtins4.c \
	  src/executing/builtins5.c \
	  src/executing/custom_readline.c \
	  src/executing/errors_exit.c \
	  src/executing/exec_cmds.c \
	  src/executing/exec_pipe.c \
	  src/executing/execute.c \
	  src/executing/free_finaltree1.c \
	  src/executing/free_finaltree2.c \
	  src/executing/handle_envvar1.c \
	  src/executing/handle_envvar2.c \
	  src/executing/handle_envvar3.c \
	  src/executing/handle_envvar4.c \
	  src/executing/heredoc_utils1.c \
	  src/executing/heredoc_utils2.c \
	  src/executing/redir_heredoc1.c \
	  src/executing/redir_heredoc2.c \
	  src/executing/redir_heredoc3.c \
	  src/executing/exec_redir_andor1.c \
	  src/executing/exec_redir_andor2.c \
	  src/wildcards/wildcards_in_out.c \
	  src/wildcards/wildcards_sort.c \
	  src/wildcards/wildcards_utils.c \
	  src/wildcards/wildcards_utils2.c \
	  src/wildcards/wildcards.c \
	  src/cmd_args_utils.c \
	  src/cmd_args.c \
	  src/cmdstruct_init1.c \
	  src/cmdstruct_init2.c \
	  src/free_memory1.c \
	  src/free_memory2.c \
	  src/get_type1.c \
	  src/get_type2.c \
	  src/get_type3.c \
	  src/last_set1.c \
	  src/last_set2.c \
	  src/main_utils.c \
	  src/main.c \
	  src/parsing_utils1.c \
	  src/parsing_utils2.c \
	  src/parsing1.c \
	  src/parsing2.c \
	  src/safe_malloc.c \
	  src/signals1.c \
	  src/signals2.c \
	  src/utils.c \
	  src/initial_setup_util.c \
	  src/history/history_main.c

DODIR = dofile

# Define object files (define, not generate)
OBJ = $(patsubst %.c,$(DODIR)/%.o,$(SRC))
# Define dependency files (define, not generate)
DEP = $(patsubst %.o,%.d,$(OBJ))


# Default target
all: $(NAME)

#include dependency files: SHOULD BE PLACED AFTER DEFAULT TARGET!
-include $(DEP)

# Rule to link the program
$(NAME): $(OBJ) $(LFT)	
	$(CC) $(OBJ) $(LIB_PATH) $(LDLIBS) -o $(NAME)

# Rule to compile source files into object files, d files are generated as well at the same time when -MMD is included
$(OBJ): $(DODIR)/%.o: %.c | $(DODIR)
	@mkdir -p $(dir $@)	
	$(CC) $(CFLAGS) $(H_PATH) -c $< -o $@ -MF $(DODIR)/$*.d

# rule to create the diretories. -p makes sure that if they exist already, nothing will be done
$(DODIR):
	mkdir -p $@

$(LFT):
	make -C ./lib/libft all

# Rule to clean object files and other temporary files
clean:
	rm -f $(OBJ) $(DEP)
	make -C ./lib/libft clean

# Rule to fully clean the project, including the executable
fclean: clean
	rm -f $(NAME)
	make -C ./lib/libft fclean

# Rule to re-make the project
re: fclean all

# Phony targets for make commands
.PHONY: all clean fclean re