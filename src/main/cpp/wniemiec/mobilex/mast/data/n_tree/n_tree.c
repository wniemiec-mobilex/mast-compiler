#include "n_tree.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../text/string_utils.h"


//-----------------------------------------------------------------------------
//		Functions                                                
//-----------------------------------------------------------------------------
void display_nodes(node* root, FILE* output_file)
{
	if(root == NULL) 
	{
		return;
	}

	char* node_label = (root->key).label;
    fprintf(output_file, "%p [label=\"%s\"];\n", root, node_label);
	
	node* p=root->child;
	
	while (p)
	{
		display_nodes(p, output_file);
		p = p->brother;
	}
}

void display_edge(node* root, node* child, FILE* output_file)
{
	fprintf(output_file, "%p, %p\n", root, child);
}

void display_edges(node* root, FILE* output_file)
{
	if(root == NULL) 
	{
		return;
	}

	node* p = root->child;
	
	while (p)
	{
		display_edge(root, p, output_file);
		display_edges(p, output_file);
		p = p->brother;
	}
}

void export_tree(void* tree, const char* output)
{
	FILE* output_file = fopen(output, "w+");
	
    display_edges((node*) tree, output_file);
    display_nodes((node*) tree, output_file);

	fclose(output_file);
}

void __free_tree(node* root)
{
	if(root == NULL) 
	{
		return;
	}
	
	node* p = root->child;
	free(root);
	
	while (p)
	{
		node* i = p->brother;
		__free_tree(p);
		p=i;
	}	
}

void free_tree(void* tree)
{
    __free_tree((node*) tree);
}

node* create_node(node* n, node* parent)
{
	if (parent == NULL)
	{
		return n;
	}
	
	if (n == NULL)
	{
		return parent;
	}

	node* p = parent->child;
	
	if (!p) 
	{
		parent->child = n;
	}
	else 
	{
		while (p->brother) 
		{
			p = p->brother;
		}

		p->brother = n;
	}

	return parent;
}

node* create_2node(node* child1, node* child2, node* parent)
{
	if (child2 == NULL) 
	{
		return create_node(child1, parent);
	}

	if (child1 == NULL) 
	{
		return create_node(child2, parent);
	}

	if (parent == NULL)	
	{
		child1->brother = child2;
		return child1;
	}

	node* p = parent->child;
	if (!p) 
	{
		parent->child = child1;
		parent->child->brother = child2;
	}
	else 
	{
		while (p->brother)
		{
			p = p->brother;
		}

		p->brother = child1;
		p->brother->brother = child2;
	}
	return parent;
}

node* create_3node(node* child1, node* child2, node* child3, node* parent)
{
	if (parent == NULL)
	{
		child1->brother = child2;
		return child1;
	}

	node* p = parent->child;
	if (!p) 
	{
		parent->child = child1;
		parent->child->brother = child2;
		parent->child->brother->brother = child3;
	}
	else 
	{
		while (p->brother)
		{
			p = p->brother;
		}

		p->brother = child1;
		p->brother->brother = child2;
		p->brother->brother->brother = child3;
	}
	return parent;
}

node* create_n_node(list_node* nodes, node* parent)
{
	list_node* current_node = nodes;

	while (current_node != NULL)
	{
		create_node(current_node->value, parent);
		current_node = current_node->next;
	}

	return parent;
}

node* create_json_node(node* child, node* parent)
{
	if (child == NULL) 
	{
		return parent;
	}

	(child->key).label = replace_str((child->key).label, "\"", "\\\"");

	return create_node(child, parent);
}

node* to_node(lexeme lex, bool escape_quotes)
{
	node* new_node = (node*) malloc(sizeof(node));
	
	new_node->child = NULL;
	new_node->brother = NULL;
	new_node->key = generate_key_from_lexeme(lex, escape_quotes);

	return new_node;
}

lexeme generate_key_from_lexeme(lexeme lex, bool escape_quotes)
{
	lexeme key;

    key.label = lex.label;
    key.line_number = lex.line_number;

	if (escape_quotes)
		key.label = replace_str(key.label, "\"", "\\\"");

	return key;
}

node* merge_nodes_label(node* n1, node* n2)
{
	if (n2 == NULL) 
	{
		return n1;
	}
	
	char* txt = (char*) malloc(sizeof(char)*10000);
	
	strcat(txt, (n1->key).label);
	strcat(txt, (n2->key).label);
	(n1->key).label = txt;
	
	return n1;
}

void append_list_nodes(node* n, list_node* nodes)
{
	if ((n == NULL) || (nodes == NULL)) 
	{
		return;
	}

	list_node* position = nodes;

	while (position->value != NULL)
	{
		if (position->next == NULL)
		{
			position->next = initialize_list_nodes();
		}
		
		position = position->next;
	}

	position->value = n;
}

list_node* initialize_list_nodes()
{
	list_node* new_list = (list_node*) malloc(sizeof(list_node));

	new_list->value = NULL;
	new_list->next = NULL;

	return new_list;
}
