/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   free_finaltree2.c                                  :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: caibei <caibei@student.42.fr>              +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/05/17 10:48:39 by bcai              #+#    #+#             */
/*   Updated: 2025/12/03 22:34:53 by caibei           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "minishell.h"

void	free_lr_list(t_cmd *left, t_cmd *right, t_m *m)
{
	free_tree(left, m);
	free_tree(right, m);
}

void	free_lr_pipe(t_cmd *left, t_cmd *right, t_m *m)
{
	free_tree(left, m);
	free_tree(right, m);
}

void	free_lr_and(t_cmd *left, t_cmd *right, t_m *m)
{
	free_tree(left, m);
	if (m->exit_status == 0)
		free_tree(right, m);
}

void	free_lr_or(t_cmd *left, t_cmd *right, t_m *m)
{
	free_tree(left, m);
	if (m->exit_status != 0)
		free_tree(right, m);
}
