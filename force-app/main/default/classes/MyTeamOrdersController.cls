public class MyTeamOrdersController {

    public decimal SumOrders {
        get{
            Id userId = UserInfo.getUserId();

            //Selectionner les enregistrement de Account Team Member 

            List<AccountTeamMember> members = [SELECT Id, AccountId FROM AccountTeamMember WHERE UserId = :userId];
            
            //Obtenir tous les Id des Accounts

            Set<Id> accountIds = new Set<Id>();
            for(AccountTeamMember member : members){
                accountIds.add(member.AccountId);
            }

            //Calculer la somme du montant total pour l'équipe de l'utilisateur en ligne

            //List<Account> acc = [SELECT Id FROM Account WHERE Id IN :accountIds];
            AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order WHERE status ='Activated' AND AccountId IN :accountIds];
            return (decimal)groupedResults.get('total');
        }
        set;
    }
}