public class MyTeamOrdersController {

    public decimal SumOrders {
        get{
            Id userId = UserInfo.getUserId();

            //Récupération des enregistrements de Account Team Member dont est membre l'utilisateur connecté

            List<AccountTeamMember> members = [SELECT Id, AccountId FROM AccountTeamMember WHERE UserId = :userId];
            
            //Obtenir tous les Id des Accounts

            Set<Id> accountIds = new Set<Id>();
            for(AccountTeamMember member : members){
                accountIds.add(member.AccountId);
            }

            //Calculer la somme du montant total des orders pour l'équipe de l'utilisateur connecté

            //List<Account> acc = [SELECT Id FROM Account WHERE Id IN :accountIds];
            AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order WHERE status ='Activated' AND AccountId IN :accountIds];
            return (decimal)groupedResults.get('total');
        }
        set;
    }
}