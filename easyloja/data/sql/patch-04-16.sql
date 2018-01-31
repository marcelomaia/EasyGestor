UPDATE till_entry
SET description = replace(description, 'Quantia removida do caixa em', 'Quantia removida do caixa referente ao dia')
WHERE id IN
    (SELECT id
     FROM till_entry
     WHERE description LIKE '%Quantia removida do caixa em%');